/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { BaseAppInstaller } from '../installer/BaseAppInstaller';

/**
 * 保存每个应用使用的下载器
 */
export class InstallDataManager {
  private static mInstance: InstallDataManager;

  /**
   * 正在下载的任务Map，key是bundleName， value是Installer
   */
  private downloadTaskMap: Map<string, BaseAppInstaller> = new Map();

  private constructor() {
  }

  public static getInstance(): InstallDataManager {
    if (!InstallDataManager.mInstance) {
      InstallDataManager.mInstance = new InstallDataManager();
    }
    return InstallDataManager.mInstance;
  }

  /**
   * 获取所有正在下载的任务
   * @returns
   */
  public getAllTask(): string[] {
    let retArr: string[] = [];
    let keys = this.downloadTaskMap.keys();
    for (let key of keys) {
      retArr.push(key);
    }
    return retArr;
  }

  /**
   * 根据bundleName添加任务
   * @param bundleName
   * @param installer
   */
  public addTask(bundleName: string, installer: BaseAppInstaller): void {
    this.downloadTaskMap.set(bundleName, installer);
  }

  /**
   * 根据bundleName是否有任务
   * @param bundleName
   * @returns
   */
  public hasTask(bundleName: string): boolean {
    return this.downloadTaskMap.has(bundleName);
  }

  /**
   * 根据bundleName查找任务
   * @param bundleName
   * @returns
   */
  public getTask(bundleName: string): BaseAppInstaller | undefined {
    return this.downloadTaskMap.get(bundleName);
  }

  /**
   * 根据bundleName删除任务
   * @param bundleName
   * @returns
   */
  public removeTask(bundleName: string): void {
    this.downloadTaskMap.delete(bundleName);
  }
}