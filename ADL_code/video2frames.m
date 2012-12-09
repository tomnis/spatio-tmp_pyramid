function video2frames(video_fname, frames_path)
mkdir(frames_path)
cmd = ['ffmpeg -i ' video_fname ' ' frames_path '/%6d.jpg'];
unix(cmd);

