package com.xm.admin.module.storage.service;

import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class StorageFactory {

    Map<String, IStorage> storageMap;

    public StorageFactory(Map<String, IStorage> storageMap) {
        this.storageMap = storageMap;
    }

    public IStorage getStorage(String name) throws RuntimeException{
        IStorage strategy = storageMap.get(name);
        if(strategy == null) {
            throw new RuntimeException("Storage type not found.");
        }
        return strategy;
    }
}
