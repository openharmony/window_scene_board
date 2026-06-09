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

import rpc from '@ohos.rpc';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import image from '@ohos.multimedia.image';
import bundleManager from '@ohos.bundle.bundleManager';


const TAG = 'ScbServiceRemoteObject';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ScbServiceRemoteObject extends rpc.RemoteObject {
  constructor() {
    super('SCBService');
  }

  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    let res = await this.checkAppPermissions();
    if (!res) {
      return false;
    }

    try {
      const SAMPLE_MANAGEMENT_REQ_CODE = 1;
      if (code === SAMPLE_MANAGEMENT_REQ_CODE) {
        log.showInfo('RpcServer: sync onRemoteMessageRequest is called, code 1');
        await this.getWatermarkFromRawData(data, reply);
        return true;
      } else {
        log.showInfo(`RpcServer: unknown code: ${code}`);
        return false;
      }
    } catch (err) {
      log.showError(`onRemoteMessageRequest failed: ${err}`);
      return false;
    }
  }

  async checkAppPermissions(): Promise<boolean> {
    let callerUid = rpc.IPCSkeleton.getCallingUid();
    const SAMPLE_MANAGEMENT = 'com.ohos.samplemanagement';

    try {
      const BUNDLE_NAME = await bundleManager.getBundleNameByUid(callerUid);
      let appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
      let applicationInfo = await bundleManager.getApplicationInfo(BUNDLE_NAME, appFlags);

      if ((BUNDLE_NAME === SAMPLE_MANAGEMENT) && applicationInfo.systemApp) {
        log.showInfo(`bundleName ${BUNDLE_NAME} is vaild and ${BUNDLE_NAME} is systemApp, the caller is in trustlist`);
        return true;
      } else {
        log.showError(`bundleName ${BUNDLE_NAME} is not in trustlist, bundleName ${BUNDLE_NAME} appSystem permission is ${applicationInfo.systemApp}, reject`);
        return false;
      }
    } catch (err) {
      log.showError(`check caller fail because ${err.message}`);
      return false;
    }
  }

  async getWatermarkFromRawData(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    log.showInfo('getWatermarkFromRawData begin');
    return new Promise((resolve, reject) => {
      class Sequenceable implements rpc.Parcelable {
        private pixelMap: image.PixelMap | undefined = undefined;

        marshalling(messageSequence: rpc.MessageSequence): boolean {
          this.pixelMap?.marshalling(messageSequence);
          return true;
        }

        unmarshalling(messageSequence: rpc.MessageSequence): boolean {
          const pixelMap = image.createPixelMapFromParcel(messageSequence);
          AppStorage.setOrCreate('watermarkImage', pixelMap);
          log.showInfo('getWatermarkFromRawData end, watermarkImage is set');
          return true;
        }
      }

      let startTime = new Date().getTime();
      try {
        data.readParcelable(new Sequenceable());
      } catch (err) {
        log.error('data.readParcelable promise::try catch : ', err);
      }
      let readRawDataCostTime = new Date().getTime() - startTime;
      log.showInfo(`readRawData cost ${readRawDataCostTime}ms`);
      resolve();
    });
  }
}