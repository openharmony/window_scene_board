/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { Context, contextConstant } from '@kit.AbilityKit';
import { ContextModifyUtils, GlobalContext } from '@ohos/frameworkwrapper';
import { BackupExtensionContext } from '@kit.CoreFileKit';

const RDB_PATH = '/rdb/';

export abstract class BackupBaseProcessor {
  protected baseBackupPath = this.getBasePath();
  protected baseRestorePath = this.getRestoreDbPath();

  protected context: Context;

  /**
   * 待恢复文件读取解析处理
   */
  public abstract saveFunc: () => Promise<void>;

  /**
   * 待恢复文件地址列表
   *
   * @returns 待恢复文件地址列表
   */
  public abstract backupPathList(): CloneParam[];

  /**
   * 数据重置
   */
  public abstract resetData(): void;

  constructor(context: Context) {
    this.context = context;
  }

  private getBasePath(): string {
    let context = GlobalContext.getInstance().getObject('desktopContext') as BackupExtensionContext;
    let basePath = '';
    let callback: Function = (contextCallback: Context) => {
      basePath = (contextCallback as BackupExtensionContext).backupDir;
    };
    ContextModifyUtils.modifyTargetContext(context, contextConstant.AreaMode.EL2,
      callback, `BackupBaseProcessor-getStore`);
    return basePath;
  }

  private getRestoreDbPath(): string {
    let context =
      (GlobalContext.getInstance().getObject('desktopContext') as BackupExtensionContext).getApplicationContext();
    let basePath = '';
    let callback: Function = (contextCallback: Context) => {
      basePath = contextCallback.databaseDir;
    };
    ContextModifyUtils.modifyTargetContext(context, contextConstant.AreaMode.EL1,
      callback, `BackupBaseProcessor-getRestoreDbPath`);
    return basePath + RDB_PATH;
  }
}

export class CloneParam {
  public sourcePath?: string;
  public targetPath?: string;
  public sourceFile?: string;
  public targetFile?: string;
}

export enum NtfHwRemindFlagIdxEnum {
  LOCK_SCREEN = 0,
  BANNER = 1,
  SOUND = 2,
  VIBRATION = 3
}