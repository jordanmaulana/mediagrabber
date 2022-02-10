package com.example.mediagrabber.Statics;


import com.example.mediagrabber.Models.Downloadable_resource_model;
import com.example.mediagrabber.Models.FileType;
import com.example.mediagrabber.Models.resourse_holder_model;

import java.util.ArrayList;
import java.util.List;

public class static_variables {
    public static resourse_holder_model resourse_holder;


    public static Downloadable_resource_model get_by_type_position(FileType _type, int position) {
        List<Downloadable_resource_model> list;
        if (_type == FileType.VIDEO) {
            list = resourse_holder.getVideo_files();
        } else if (_type == FileType.IMAGE) {
            list = resourse_holder.getImage_files();
        } else if (_type == FileType.AUDIO) {
            list = resourse_holder.getAudio_files();
        } else {
            return null;
        }
        if (list != null) {
            return list.get(position);
        } else {
            return null;
        }
    }

    public static ArrayList<Downloadable_resource_model> get_downloadable_resource_model_By_Type(FileType _type) {
        if (_type == FileType.VIDEO) {
            return resourse_holder.getVideo_files();
        } else if (_type == FileType.IMAGE) {
            return resourse_holder.getImage_files();
        } else if (_type == FileType.AUDIO) {
            return resourse_holder.getAudio_files();
        } else {
            return null;
        }
    }

}
