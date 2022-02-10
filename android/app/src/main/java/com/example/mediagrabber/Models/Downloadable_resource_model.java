package com.example.mediagrabber.Models;

import android.graphics.Bitmap;

import com.example.mediagrabber.Utils.Utils;

import java.util.HashMap;
import java.util.Map;

public class Downloadable_resource_model {
    private String Title;
    private String URL;
    private FileType FileType;
    private String file_size;
    private Bitmap preview;

    public Downloadable_resource_model(String title, String URL, FileType file_type, String file_size) {
        Title = title;
        this.URL = URL;
        this.FileType = file_type;
        this.file_size = file_size;
    }

    public Map<String, Object> toJson() {
        return new HashMap<String, Object>() {
            {
                put("title", Title);
                put("url", URL);
                put("tyoe", FileType);
            }
        };
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
    }

    public FileType getFile_type() {
        return FileType;
    }

    public void setFile_type(FileType file_type) {
        this.FileType = file_type;
    }

    public String getFile_size() {
        if (file_size != null && !file_size.equals("")) {
            try {
                return Utils.formatFileSize(Long.parseLong(file_size));
            } catch (Exception ex) {
                return file_size;
            }
        } else {
            return file_size;
        }
    }

    public void setFile_size(String file_size) {
        this.file_size = file_size;
    }

    public Bitmap getPreview() {
        return preview;
    }

    public void setPreview(Bitmap preview) {
        this.preview = preview;
    }

}
