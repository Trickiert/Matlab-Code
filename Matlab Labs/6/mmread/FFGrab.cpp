/***************************************************
This is the main Grabber code.  It uses AVbin and ffmpeg
to capture video and audio from video and audio files.
Because of this, mmread and supporting code is now 
distributed under the LGPL.  See 

The code supports any number of audio or video streams and 
is a cross platform solution to replace DDGrab.cpp.

This code was intended to be used inside of a matlab interface,
but can be used as a generic grabber class for anyone who needs
one.

Copyright 2008 Micah Richert

This file is part of mmread.

mmread is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 3 of
the License, or (at your option) any later version.

mmread is distributed WITHOUT ANY WARRANTY.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public
License along with mmread.  If not, see <http://www.gnu.org/licenses/>.
**************************************************/

#ifdef MATLAB_MEX_FILE
#include "mex.h"
#define FFprintf(...) mexPrintf(__VA_ARGS__)
#else
#define FFprintf(...) printf(__VA_ARGS__)
#endif

//#ifndef mwSize
//#define mwSize int
//#endif

#define DEBUG 0

extern "C" {
	#include <avbin.h>
	#include <libavformat/avformat.h>
	
	struct _AVbinFile {
	    AVFormatContext *context;
	    AVPacket *packet;
	};
}

#include <stdlib.h>
#include <string.h>
#include <vector>
#include <map>
using namespace std;

class Grabber
{
public:
	Grabber(bool isAudio, AVbinStream* stream, bool trySeeking, double rate, int bytesPerWORD, AVbinStreamInfo info, AVbinTimestamp start_time)
	{
		this->stream = stream;
		frameNr = 0;
		done = false;
		this->bytesPerWORD = bytesPerWORD;
		this->rate = rate;
		startTime = 0;
		stopTime = 0;
		this->isAudio = isAudio;
		this->info = info;
		this->trySeeking = trySeeking;
		this->start_time = start_time;
	};
	
	~Grabber()
	{
		// clean up any remaining memory...
		if (DEBUG) FFprintf("freeing frame data...\n");
		for (vector<uint8_t*>::iterator i=frames.begin();i != frames.end(); i++) free(*i);
	}
	
	AVbinStream* stream;
	AVbinStreamInfo info;
	AVbinTimestamp start_time;
	
	vector<uint8_t*> frames;
	vector<unsigned int> frameBytes;
	vector<double> frameTimes;

	vector<unsigned int> frameNrs;

	unsigned int frameNr;
	bool done;
	bool isAudio;
	bool trySeeking;

	int bytesPerWORD;
	double rate;
	double startTime, stopTime;
	
	int Grab(AVbinPacket* packet)
	{
		if (done) return 0;
		if (!packet->data) return 1;
	
		frameNr++;
		if (DEBUG) FFprintf("frameNr %d %d\n",frameNr,packet->size);
		int offset=0, len=0;
		double timestamp = (packet->timestamp-start_time)/1000.0/1000.0;
	
		// either no frames are specified (capture all), or we have time specified
		if (stopTime)
		{
			if (isAudio)
			{
				// time is being used...
				if (timestamp >= startTime)
				{
					// if we've reached the start...
					offset = max(0,((int)((startTime-timestamp)*rate))*bytesPerWORD);
					len = ((int)((stopTime-timestamp)*rate))*bytesPerWORD;
					// if we have gone past our stop time...

					done = len < 0;
				}
			} else {
				done = stopTime <= timestamp;
				len = (startTime <= timestamp)?0x7FFFFFFF:0;
				if (DEBUG) FFprintf("startTime: %lf, stopTime: %lf, current: %lf, done: %d, len: %d\n",startTime,stopTime,timestamp,done,len);
			}
		} else {
			// capture everything... video or audio
			len = 0x7FFFFFFF;
		}
 				
		if (trySeeking && (len<=0 || done)) return 0;

		if (isAudio)
		{
			uint8_t audiobuf[1024*1024];
			int uint8_tsleft = sizeof(audiobuf);
 			int uint8_tsout = uint8_tsleft;
			int uint8_tsread;
			uint8_t* audiodata = audiobuf;
			if (DEBUG) FFprintf("avbin_decode_audio\n");
			while ((uint8_tsread = avbin_decode_audio(stream, packet->data, packet->size, audiodata, &uint8_tsout)) > 0)
			{
				packet->data += uint8_tsread;
				packet->size -= uint8_tsread;
				audiodata += uint8_tsout;
				uint8_tsleft -= uint8_tsout;
				uint8_tsout = uint8_tsleft;
			}

			int nrBytes = audiodata-audiobuf;
			len = min(len,nrBytes);
			offset = min(offset,nrBytes);

			uint8_t* tmp = (uint8_t*)malloc(len);
			if (!tmp) return 2;
	
			memcpy(tmp,audiobuf+offset,len);
	
			frames.push_back(tmp);
			frameBytes.push_back(len);
			frameTimes.push_back(timestamp);

		} else {
			bool skip = false;
			if (frameNrs.size() > 0)
			{
				//frames are being specified
				// check to see if the frame is in our list
				bool foundNr = false;
				int lastFrameNr = 0;
				for (int i=0;i<frameNrs.size();i++)
				{
					if (frameNrs.at(i) == frameNr) foundNr = true;
					if (frameNrs.at(i) > lastFrameNr) lastFrameNr = frameNrs.at(i);
				}
		
				done = frameNr > lastFrameNr;
				if (!foundNr) {
					if (DEBUG) FFprintf("Skipping frame %d\n",frameNr);
					skip = true;
				}
			}
			if ((trySeeking && skip) || done) return 0;
			
			uint8_t* videobuf = (uint8_t*)malloc(bytesPerWORD);
			if (!videobuf) return 2;
			if (DEBUG) FFprintf("avbin_decode_video\n");

			if (avbin_decode_video(stream, packet->data, packet->size,videobuf)<=0)
			{
				if (DEBUG) FFprintf("avbin_decode_video FAILED!!!\n");
				// silently ignore decode errors
				frameNr--;
				return 3;
			}
			if (skip)
			{
				free(videobuf);
				return 0;
			}
			frames.push_back(videobuf);
			frameBytes.push_back(min(len,bytesPerWORD));
			frameTimes.push_back(timestamp);
		}

		return 0;
	}
};

typedef map<int,Grabber*> streammap;

class FFGrabber
{
public:
	FFGrabber();
	
	int build(char* filename, bool disableVideo, bool disableAudio, bool tryseeking);
	int doCapture();

	int getVideoInfo(unsigned int id, int* width, int* height, double* rate, int* nrFramesCaptured, int* nrFramesTotal, double* totalDuration);
	int getAudioInfo(unsigned int id, int* nrChannels, double* rate, int* bits, int* nrFramesCaptured, int* nrFramesTotal, int* subtype, double* totalDuration);
	void getCaptureInfo(int* nrVideo, int* nrAudio);
	// data must be freed by caller
	int getVideoFrame(unsigned int id, int frameNr, uint8_t** data, unsigned int* nrBytes, double* time);
	// data must be freed by caller
	int getAudioFrame(unsigned int id, int frameNr, uint8_t** data, unsigned int* nrBytes, double* time);
	void setFrames(int* frameNrs, int nrFrames);
	void setTime(double startTime, double stopTime);
	void disableVideo();
	void disableAudio();
	void cleanUp(); // must be called at the end, in order to render anything afterward.

#ifdef MATLAB_MEX_FILE
	void setMatlabCommand(char * matlabCommand);
	void runMatlabCommand(Grabber* G);
#endif
private:
	streammap streams;
	vector<Grabber*> videos;
	vector<Grabber*> audios;
	
	AVbinFile* file;
	AVbinFileInfo fileinfo;
	
	bool stopForced;
	bool tryseeking;
	vector<int> frameNrs;
	double startTime, stopTime;

#ifdef MATLAB_MEX_FILE
	char* matlabCommand;
#endif
};


FFGrabber::FFGrabber()
{
	stopForced = false;
	tryseeking = true;
	file = NULL;
	
	if (DEBUG) FFprintf("avbin_init\n");
 	if (avbin_init()) FFprintf("avbin_init init failed!!!\n");
}

void FFGrabber::cleanUp()
{
	if (!file) return; // nothing to cleanup.
	
	for (streammap::iterator i = streams.begin(); i != streams.end(); i++)
	{
		avbin_close_stream(i->second->stream);
		delete i->second;
	}
 	
 	streams.clear();
 	videos.clear();
 	audios.clear();

 	avbin_close_file(file);
 	file = NULL;
 	
#ifdef MATLAB_MEX_FILE
	if (matlabCommand) free(matlabCommand);
	matlabCommand = NULL;
#endif
}

int FFGrabber::getVideoInfo(unsigned int id, int* width, int* height, double* rate, int* nrFramesCaptured, int* nrFramesTotal, double* totalDuration)
{
	if (!width || !height || !nrFramesCaptured || !nrFramesTotal) return -1;

	if (id >= videos.size()) return -2;
	Grabber* CB = videos.at(id);

	if (!CB) return -1;

	*width  = CB->info.video.width;
	*height = CB->info.video.height;
	*rate = CB->rate;
	*nrFramesCaptured = CB->frames.size();
	*nrFramesTotal = CB->frameNr;

	*totalDuration = fileinfo.duration/1000.0/1000.0;
	if (stopForced) *nrFramesTotal = -(*rate)*(*totalDuration);
    
	return 0;
}

int FFGrabber::getAudioInfo(unsigned int id, int* nrChannels, double* rate, int* bits, int* nrFramesCaptured, int* nrFramesTotal, int* subtype, double* totalDuration)
{
	if (!nrChannels || !rate || !bits || !nrFramesCaptured || !nrFramesTotal) return -1;

	if (id >= audios.size()) return -2;
	Grabber* CB = audios.at(id);

	if (!CB) return -1;

	*nrChannels = CB->info.audio.channels;
	*rate = CB->info.audio.sample_rate;
	*bits = CB->info.audio.sample_bits;
	*subtype = CB->info.audio.sample_format;
	*nrFramesCaptured = CB->frames.size();
	*nrFramesTotal = CB->frameNr;

	*totalDuration = fileinfo.duration/1000.0/1000.0;
    
	return 0;
}

void FFGrabber::getCaptureInfo(int* nrVideo, int* nrAudio)
{
	if (!nrVideo || !nrAudio) return;

	*nrVideo = videos.size();
	*nrAudio = audios.size();
}

// data must be freed by caller
int FFGrabber::getVideoFrame(unsigned int id, int frameNr, uint8_t** data, unsigned int* nrBytes, double* time)
{
	if (!data || !nrBytes) return -1;

	if (id >= videos.size()) return -2;
	Grabber* CB = videos[id];
	if (!CB) return -1;
	if (CB->frameNr == 0) return -2;
	if (frameNr < 0 || frameNr >= CB->frames.size()) return -2;

	uint8_t* tmp = CB->frames[frameNr];
	if (!tmp) return -2;

	*nrBytes = CB->frameBytes[frameNr];
	*time = CB->frameTimes[frameNr];

	*data = tmp;
	CB->frames[frameNr] = NULL;

	return 0;
}

// data must be freed by caller
int FFGrabber::getAudioFrame(unsigned int id, int frameNr, uint8_t** data, unsigned int* nrBytes, double* time)
{
	if (!data || !nrBytes) return -1;

	if (id >= audios.size()) return -2;
	Grabber* CB = audios[id];
	if (!CB) return -1;
	if (CB->frameNr == 0) return -2;
	if (frameNr < 0 || frameNr >= CB->frames.size()) return -2;

	uint8_t* tmp = CB->frames[frameNr];
	if (!tmp) return -2;

	*nrBytes = CB->frameBytes[frameNr];
	*time = CB->frameTimes[frameNr];

	*data = tmp;
	CB->frames[frameNr] = NULL;

	return 0;
}

void FFGrabber::setFrames(int* frameNrs, int nrFrames)
{
	if (!frameNrs) return;
	
	this->frameNrs.clear();
	for (int i=0; i<nrFrames; i++) this->frameNrs.push_back(frameNrs[i]);

	for (int i=0; i < videos.size(); i++)
	{
		Grabber* CB = videos.at(i);
		if (CB)
		{
			CB->frames.clear();
			CB->frameNrs.clear();
			for (int i=0; i<nrFrames; i++) CB->frameNrs.push_back(frameNrs[i]);
			CB->frameNr = 0;
		}
	}
    
	// the meaning of frames doesn't make much sense for audio...
}


void FFGrabber::setTime(double startTime, double stopTime)
{
	this->startTime = startTime;
	this->stopTime = stopTime;
	frameNrs.clear();
	
	for (int i=0; i < videos.size(); i++)
	{
		Grabber* CB = videos.at(i);
		if (CB)
		{
			CB->frames.clear();
			CB->frameNrs.clear();
			CB->frameNr = 0;
			CB->startTime = startTime;
			CB->stopTime = stopTime;
		}
	}

	for (int i=0; i < audios.size(); i++)
	{
		Grabber* CB = audios.at(i);
		if (CB)
		{
			CB->frames.clear();
			CB->frameNrs.clear();
			CB->startTime = startTime;
			CB->stopTime = stopTime;
		}
	}
}

#ifdef MATLAB_MEX_FILE
void FFGrabber::setMatlabCommand(char * matlabCommand)
{
	this->matlabCommand = matlabCommand;
}

void FFGrabber::runMatlabCommand(Grabber* G)
{
	if (matlabCommand)
	{
		mwSize dims[2];
		dims[1]=1;
		int width=G->info.video.width, height = G->info.video.height;
		mxArray* plhs[] = {NULL};
		mxArray* prhs[5];
		int ExitCode;
		prhs[0] = NULL;

		mexSetTrapFlag(0);

		prhs[1] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(prhs[1])[0] = width;
		prhs[2] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(prhs[2])[0] = height;
		prhs[3] = mxCreateDoubleMatrix(1,1,mxREAL); 
		prhs[4] = mxCreateDoubleMatrix(1,1,mxREAL); 

		if (G->frames.size() == 0) return;
		vector<uint8_t*>::iterator lastframe = --(G->frames.end());
		
		if (*lastframe == NULL) return;
		
		dims[0] = G->frameBytes.back();
		
		//make matrices to pass to the matlab function
		prhs[0] = mxCreateNumericArray(2, dims, mxUINT8_CLASS, mxREAL); // empty 2d matrix
		memcpy(mxGetPr(prhs[0]),*lastframe,dims[0]);
		
		mxGetPr(prhs[3])[0] = G->frameNrs.size()==0?G->frameTimes.size():G->frameNrs[G->frameTimes.size()-1];
		mxGetPr(prhs[4])[0] = G->frameTimes.back();

		//free the frame memory
		free(*lastframe);
		*lastframe = NULL;

		//call Matlab
		ExitCode = mexCallMATLAB(0,plhs,5,prhs,matlabCommand);

		//free memory
		mxDestroyArray(prhs[0]);
		prhs[0] = NULL;
		mxDestroyArray(prhs[1]);
		mxDestroyArray(prhs[2]);
		mxDestroyArray(prhs[3]);
		mxDestroyArray(prhs[4]);
	}
}
#endif

int FFGrabber::build(char* filename, bool disableVideo, bool disableAudio, bool tryseeking)
{
	if (DEBUG) FFprintf("avbin_open_filename\n");
 	file = avbin_open_filename(filename);
 	if (!file) return -4;

	fileinfo.structure_size = sizeof(fileinfo);

	if (DEBUG) FFprintf("avbin_file_info\n");
	if (avbin_file_info(file, &fileinfo)) return -1;

	for (int stream_index=0; stream_index<fileinfo.n_streams; stream_index++)
	{
		AVbinStreamInfo streaminfo;
		streaminfo.structure_size = sizeof(streaminfo);

		if (avbin_get_version() < 8)
		{
			AVbinStreamInfo streaminfo7;
			streaminfo7.structure_size = sizeof(streaminfo7);
			
			if (DEBUG) FFprintf("avbin_stream_info7 and copying values...\n");
			avbin_stream_info(file, stream_index, (AVbinStreamInfo*)&streaminfo7);
			streaminfo.type = streaminfo7.type;
			streaminfo.video.width = streaminfo7.video.width;
			streaminfo.video.height = streaminfo7.video.height;
			streaminfo.audio.sample_format = streaminfo7.audio.sample_format;
			streaminfo.audio.sample_rate = streaminfo7.audio.sample_rate;
			streaminfo.audio.sample_bits = streaminfo7.audio.sample_bits;
			streaminfo.audio.channels = streaminfo7.audio.channels;
		} else {
			if (DEBUG) FFprintf("avbin_stream_info\n");
			avbin_stream_info(file, stream_index, &streaminfo);
		}
			
		if (streaminfo.type == AVBIN_STREAM_TYPE_VIDEO && !disableVideo)
		{
			AVbinStream * tmp = avbin_open_stream(file, stream_index);
			if (tmp)
			{
				double rate = streaminfo.video.frame_rate_num/(0.00001+streaminfo.video.frame_rate_den);					

				streams[stream_index]=new Grabber(false,tmp,tryseeking,rate,streaminfo.video.height*streaminfo.video.width*3,streaminfo,fileinfo.start_time);
				videos.push_back(streams[stream_index]);
			} else {
				FFprintf("Could not open video stream\n");
			}
		}
		if (streaminfo.type == AVBIN_STREAM_TYPE_AUDIO && !disableAudio)
		{
			AVbinStream * tmp = avbin_open_stream(file, stream_index);
			if (tmp)
			{
				streams[stream_index]=new Grabber(true,tmp,tryseeking,streaminfo.audio.sample_rate,streaminfo.audio.sample_bits*streaminfo.audio.channels,streaminfo,fileinfo.start_time);
				audios.push_back(streams[stream_index]);
			} else {
				FFprintf("Could not open audio stream\n");
			}
		}
	}
	this->tryseeking = tryseeking;
	stopForced = false;
	
	return 0;
}

int FFGrabber::doCapture()
{
//	if (tryseeking) I think we should always seek, if time is being specified...
	{
		if (stopTime && startTime > 0) {
			if (DEBUG) FFprintf("try seeking to %lf\n",startTime);
			avbin_seek_file(file, startTime*1000*1000);
		}
	}
    
	AVbinPacket packet;
	packet.structure_size = sizeof(packet);
	streammap::iterator tmp;
	
	bool allDone = false;
	while (!avbin_read(file, &packet))
	{
		if ((tmp = streams.find(packet.stream_index)) != streams.end())
		{
			Grabber* G = tmp->second;
			G->Grab(&packet);
			
			if (G->done)
			{
				allDone = true;
				for (streammap::iterator i = streams.begin(); i != streams.end() && allDone; i++)
				{
					allDone = allDone && i->second->done;
				}
			}
			
#ifdef MATLAB_MEX_FILE
			if (!G->isAudio) runMatlabCommand(G);
#endif
		}

		if (allDone)
		{
			if (DEBUG) FFprintf("stopForced\n");
			stopForced = true;
			break;
		}
	}
	
	return 0;
}

#ifdef MATLAB_MEX_FILE
FFGrabber FFG;

char* message(int err)
{
	switch (err)
	{
		case 0: return "";
		case -1: return "Unable to initialize";
		case -2: return "Invalid interface";
		case -4: return "Unable to open file";
		case -5: return "AVbin version 8 or greater is required!";
		default: return "Unknown error";
	}
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs < 1 || !mxIsChar(prhs[0])) mexErrMsgTxt("First parameter must be the command (a string)");

	char cmd[100];
	mxGetString(prhs[0],cmd,100);

	if (!strcmp("build",cmd))
	{
		if (nrhs < 5 || !mxIsChar(prhs[1])) mexErrMsgTxt("build: parameters must be the filename (as a string), disableVideo, disableAudio, trySeeking");
		if (nlhs > 0) mexErrMsgTxt("build: there are no outputs");
		int filenamelen = mxGetN(prhs[1])+1;
		char* filename = new char[filenamelen];
		if (!filename) mexErrMsgTxt("build: out of memory");
		mxGetString(prhs[1],filename,filenamelen);

		char* errmsg =  message(FFG.build(filename, mxGetScalar(prhs[2]), mxGetScalar(prhs[3]), mxGetScalar(prhs[4])));
		delete[] filename;

		if (strcmp("",errmsg)) mexErrMsgTxt(errmsg);
	} else if (!strcmp("doCapture",cmd)) {
		if (nlhs > 0) mexErrMsgTxt("doCapture: there are no outputs");
		char* errmsg =  message(FFG.doCapture());
		if (strcmp("",errmsg)) mexErrMsgTxt(errmsg);
	} else if (!strcmp("getVideoInfo",cmd)) {
		if (nrhs < 2 || !mxIsNumeric(prhs[1])) mexErrMsgTxt("getVideoInfo: second parameter must be the video stream id (as a number)");
		if (nlhs > 6) mexErrMsgTxt("getVideoInfo: there are only 5 output values: width, height, rate, nrFramesCaptured, nrFramesTotal");

		unsigned int id = mxGetScalar(prhs[1]);
		int width,height,nrFramesCaptured,nrFramesTotal;
		double rate, totalDuration;
		char* errmsg =  message(FFG.getVideoInfo(id, &width, &height,&rate, &nrFramesCaptured, &nrFramesTotal, &totalDuration));

		if (strcmp("",errmsg)) mexErrMsgTxt(errmsg);

		if (nlhs >= 1) {plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[0])[0] = width; }
		if (nlhs >= 2) {plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[1])[0] = height; }
		if (nlhs >= 3) {plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[2])[0] = rate; }
		if (nlhs >= 4) {plhs[3] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[3])[0] = nrFramesCaptured; }
		if (nlhs >= 5) {plhs[4] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[4])[0] = nrFramesTotal; }
		if (nlhs >= 6) {plhs[5] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[5])[0] = totalDuration; }
	} else if (!strcmp("getAudioInfo",cmd)) {
		if (nrhs < 2 || !mxIsNumeric(prhs[1])) mexErrMsgTxt("getAudioInfo: second parameter must be the audio stream id (as a number)");
		if (nlhs > 7) mexErrMsgTxt("getAudioInfo: there are only 6 output values: nrChannels, rate, bits, nrFramesCaptured, nrFramesTotal, subtype");

		unsigned int id = mxGetScalar(prhs[1]);
		int nrChannels,bits,nrFramesCaptured,nrFramesTotal,subtype;
		double rate, totalDuration;
		char* errmsg =  message(FFG.getAudioInfo(id, &nrChannels, &rate, &bits, &nrFramesCaptured, &nrFramesTotal, &subtype, &totalDuration));

		if (strcmp("",errmsg)) mexErrMsgTxt(errmsg);

		if (nlhs >= 1) {plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[0])[0] = nrChannels; }
		if (nlhs >= 2) {plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[1])[0] = rate; }
		if (nlhs >= 3) {plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[2])[0] = bits; }
		if (nlhs >= 4) {plhs[3] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[3])[0] = nrFramesCaptured; }
		if (nlhs >= 5) {plhs[4] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[4])[0] = nrFramesTotal; }
		if (nlhs >= 6) {plhs[5] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[5])[0] = subtype==AVBIN_SAMPLE_FORMAT_FLOAT?1:0; }
		if (nlhs >= 7) {plhs[6] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[6])[0] = totalDuration; }
	} else if (!strcmp("getCaptureInfo",cmd)) {
		if (nlhs > 2) mexErrMsgTxt("getCaptureInfo: there are only 2 output values: nrVideo, nrAudio");

		int nrVideo, nrAudio;
		FFG.getCaptureInfo(&nrVideo, &nrAudio);

		if (nlhs >= 1) {plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[0])[0] = nrVideo; }
		if (nlhs >= 2) {plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[1])[0] = nrAudio; }
	} else if (!strcmp("getVideoFrame",cmd)) {
		if (nrhs < 3 || !mxIsNumeric(prhs[1]) || !mxIsNumeric(prhs[2])) mexErrMsgTxt("getVideoFrame: second parameter must be the audio stream id (as a number) and third parameter must be the frame number");
		if (nlhs > 2) mexErrMsgTxt("getVideoFrame: there are only 2 output value: data");

		unsigned int id = mxGetScalar(prhs[1]);
		int frameNr = mxGetScalar(prhs[2]);
		uint8_t* data;
		unsigned int nrBytes;
		double time;
		mwSize dims[2];
		dims[1]=1;
		char* errmsg =  message(FFG.getVideoFrame(id, frameNr, &data, &nrBytes, &time));

		if (strcmp("",errmsg)) mexErrMsgTxt(errmsg);

		dims[0] = nrBytes;
		plhs[0] = mxCreateNumericArray(2, dims, mxUINT8_CLASS, mxREAL); // empty 2d matrix
		memcpy(mxGetPr(plhs[0]),data,nrBytes);
		free(data);
		if (nlhs >= 2) {plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[1])[0] = time; }
	} else if (!strcmp("getAudioFrame",cmd)) {
		if (nrhs < 3 || !mxIsNumeric(prhs[1]) || !mxIsNumeric(prhs[2])) mexErrMsgTxt("getAudioFrame: second parameter must be the audio stream id (as a number) and third parameter must be the frame number");
		if (nlhs > 2) mexErrMsgTxt("getAudioFrame: there are only 2 output value: data");

		unsigned int id = mxGetScalar(prhs[1]);
		int frameNr = mxGetScalar(prhs[2]);
		uint8_t* data;
		unsigned int nrBytes;
		double time;
		mwSize dims[2];
		dims[1]=1;
		mxClassID mxClass;
		char* errmsg =  message(FFG.getAudioFrame(id, frameNr, &data, &nrBytes, &time));

		if (strcmp("",errmsg)) mexErrMsgTxt(errmsg);

		int nrChannels,bits,nrFramesCaptured,nrFramesTotal,subtype;
		double rate, totalDuration;
		FFG.getAudioInfo(id, &nrChannels, &rate, &bits, &nrFramesCaptured, &nrFramesTotal, &subtype, &totalDuration);

		switch (bits)
		{
			case 8:
			{
		 		dims[0] = nrBytes;
				mxClass = mxUINT8_CLASS;
				break;
			}
			case 16:
			{
				mxClass = mxINT16_CLASS;
				dims[0] = nrBytes/2;
				break;
			}
			case 24:
			{
				int* tmpdata = (int*)malloc(nrBytes/3*4);
				int i;

				//I don't know how 24bit float data is organized...
				for (i=0;i<nrBytes/3;i++)
				{
					tmpdata[i] = (((0x80&data[i*3+2])?-1:0)&0xFF000000) | ((data[i*3+2]<<16)+(data[i*3+1]<<8)+data[i*3]);
				}

				free(data);
				data = (uint8_t*)tmpdata;

				mxClass = mxINT32_CLASS;
				dims[0] = nrBytes/3;
				nrBytes = nrBytes/3*4;
				break;
			}
			case 32:
			{
				mxClass = subtype==AVBIN_SAMPLE_FORMAT_S32?mxINT32_CLASS:subtype==AVBIN_SAMPLE_FORMAT_FLOAT?mxSINGLE_CLASS:mxUINT32_CLASS;
				dims[0] = nrBytes/4;
				break;
			}
			default:
			{
		 		dims[0] = nrBytes;
				mxClass = mxUINT8_CLASS;
				break;
			}
		}

		plhs[0] = mxCreateNumericArray(2, dims, mxClass, mxREAL); // empty 2d matrix
		memcpy(mxGetPr(plhs[0]),data,nrBytes);
		free(data);
		if (nlhs >= 2) {plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL); mxGetPr(plhs[1])[0] = time; }
	} else if (!strcmp("setFrames",cmd)) {
		if (nrhs < 2 || !mxIsDouble(prhs[1])) mexErrMsgTxt("setFrames: second parameter must be the frame numbers (as doubles)");
		if (nlhs > 0) mexErrMsgTxt("setFrames: has no outputs");
		int nrFrames = mxGetN(prhs[1]) * mxGetM(prhs[1]);
		int* frameNrs = new int[nrFrames];
		if (!frameNrs) mexErrMsgTxt("setFrames: out of memory");
		double* data = mxGetPr(prhs[1]);
		for (int i=0; i<nrFrames; i++) frameNrs[i] = data[i];

		FFG.setFrames(frameNrs, nrFrames);

		delete[] frameNrs;
	} else if (!strcmp("setTime",cmd)) {
		if (nrhs < 3 || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2])) mexErrMsgTxt("setTime: start and stop time are required (as doubles)");
		if (nlhs > 0) mexErrMsgTxt("setTime: has no outputs");

		FFG.setTime(mxGetScalar(prhs[1]), mxGetScalar(prhs[2]));
	} else if (!strcmp("setMatlabCommand",cmd)) {
		if (nrhs < 2 || !mxIsChar(prhs[1])) mexErrMsgTxt("setMatlabCommand: the command must be passed as a string");
		if (nlhs > 0) mexErrMsgTxt("setMatlabCommand: has no outputs");

		char * matlabCommand = (char*)calloc(100,1);
		mxGetString(prhs[1],matlabCommand,100);

		if (strlen(matlabCommand)==0) 
		{
			FFG.setMatlabCommand(NULL);
			free(matlabCommand);
		} else FFG.setMatlabCommand(matlabCommand);

	} else if (!strcmp("cleanUp",cmd)) {
		if (nlhs > 0) mexErrMsgTxt("cleanUp: there are no outputs");
		FFG.cleanUp();
	}
}
#endif

#ifdef TEST_FFGRAB
int main(int argc, char** argv)
{
	FFGrabber FFG;
printf("%s\n",argv[1]);
	FFG.build(argv[1],false,false,true);
	FFG.doCapture();
	int nrVideo, nrAudio;
	FFG.getCaptureInfo(&nrVideo, &nrAudio);
	
	printf("there are %d video streams, and %d audio.\n",nrVideo,nrAudio);
}
#endif
