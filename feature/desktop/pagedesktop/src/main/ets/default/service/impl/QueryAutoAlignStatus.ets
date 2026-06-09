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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import dataPreferences from '@ohos.data.preferences';

const TAG: string = 'QueryAutoAlignStatus';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 提供自动对齐能力接口
 *
 * @since2025-02-28
 */
export class Response {
  public static readonly success = 'OK';

  public static readonly openAutoAlign = 'AutoAlign open';

  public static readonly closeAutoAlign = 'AutoAlign close';

  public static readonly fail = 'fail';
}

export class QueryAutoAlignStatus {
  private preference: dataPreferences.Preferences | undefined;

  async execute(extra?: object): Promise<string> {
    log.showInfo('query autoAlign status');
    let context: Context = getContext().getApplicationContext();
    try {
      this.preference = await dataPreferences.getPreferences(context, 'DesktopSetting');
    } catch (e) {
      log.showError(`preference faile ${e?.code} ${e?.message}`);
      return Response.fail;
    }
    if (!this.preference) {
      log.showError('preference is undefined!');
      return Response.fail;
    }
    try {
      let result = this.preference.getSync('autoAlignStatus', false) as boolean;
      return result ? Response.openAutoAlign : Response.closeAutoAlign;
    } catch (e) {
      log.showError(`QueryAutoAlignStatus faile ${e?.code} ${e?.message}`);
      return Response.fail;
    }
  }
}

export class SetAutoAlignStatus {
  private preference: dataPreferences.Preferences | undefined;

  async execute(extra?: object): Promise<string> {
    let msg = extra as ExtraInfo;
    let context: Context = getContext().getApplicationContext();
    dataPreferences.removePreferencesFromCacheSync(context, 'DesktopSetting');
    try {
      this.preference = await dataPreferences.getPreferences(context, 'DesktopSetting');
    } catch (e) {
      log.showError(`preference faile ${e?.code} ${e?.message}`);
      return Response.fail;
    }
    if (!this.preference) {
      log.showError('preference is undefined!');
      return Response.fail;
    }
    try {
      const value = msg?.setAutoAlign;
      if (value === 'true' || value === 'false') {
        const status = value === 'true';
        log.showInfo(status ? 'open autoAlign' : 'close autoAlign');
        this.preference.putSync('autoAlignStatus', status);
        this.preference.flush(() => {
          log.showInfo('Succeeded in flushing');
        });
        return status ? Response.openAutoAlign : Response.closeAutoAlign;
      }
      return Response.fail;
    } catch (e) {
      log.showError(`SetAutoAlignStatus faile ${e?.code} ${e?.message}`);
      return Response.fail;
    }
  }
}

class ExtraInfo {
  /**
   * 开启或者关闭自动对齐
   */
  public setAutoAlign: string = '';
}