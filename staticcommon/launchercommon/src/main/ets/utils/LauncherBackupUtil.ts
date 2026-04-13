/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AccountMgr } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { Want } from '@kit.AbilityKit';
// import migrate from '@ohos.migrate';

const TAG = 'LauncherBackupUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const CALLER_MIGRATE_SERVER_CODE = 608;

/**
 * 桌面备份恢复工具类
 */
export default class LauncherBackupUtil {
  /**
   * 移除应用分身后，发布公共事件，通知迁移服务
   * @param bundleName 应用包名
   * @param appIndex 应用分身标识
   * @param appSourceType 0:未OpenHarmony化应用  1：已OpenHarmony化应用
   * @returns 
   */
  public static async reportRemoveAppTwin(bundleName: string, appIndex: number, appSourceType?: number): Promise<void> {
    let userId = await AccountMgr.getCurrentAccountId();
    try {
      log.showInfo('callMigrateServer start');
      let legacyInfo: Object = { 'pkgName': bundleName } as Record<string, string>;
      let wantInfo: Want = {
        parameters: {
          code: CALLER_MIGRATE_SERVER_CODE,
          detailData: {
            'userId': userId,
            'bundleName': bundleName,
            'appIndex': appIndex,
            'legacyInfos': [legacyInfo]
          }
        }
      };
      // migrate.getMigrator().notifyAppGalleryCoreEvent(wantInfo);
    } catch (error) {
      log.showInfo('reportRemoveAppTwin error  %{public}s', error?.message);
    }
  }
}