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
import {
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSessionManager} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'PcModeRSSUtils';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const RSS_LISTEN_TYPE_MINIMIZE_FLOAT = 9;
const RSS_LISTEN_TYPE = [
  RSS_LISTEN_TYPE_MINIMIZE_FLOAT
]

/**
 * provide rss data
 */
interface IRssDataProvider {

  /**
   * Registers the Rss callback, such as the mutex state callback.
   * When the mutex state is reached, the callback is triggered.
   * @param eventType rss type
   * @param callback
   */
  registerRssData(eventType: number, callback: Callback<Record<string, string>>): void;

  /**
   * Unregisters Rss callback
   * @param eventType
   * @param callback
   */
  unregisterRssData(eventType: number, callback: Callback<Record<string, string>>): void;

  /**
   * query Rss data sync, such ad mutex state
   * @param resType rss type
   * @param payload extra query info
   * @return query result
   */
  getRssData(resType: number, payload: Record<string, string>): Record<string, Object> | undefined;
}

class DefaultRssDataProvider implements IRssDataProvider {

  registerRssData(eventType: number, callback: Callback<Record<string, string>>) {
    try {
      sceneSessionManager.registerRssData(eventType, callback);
    } catch (e) {
      log.showError(`registerRssData faild, ${e}`)
    }
  }

  unregisterRssData(eventType: number, callback: Callback<Record<string, string>>) {
    try {
      sceneSessionManager.unregisterRssData(eventType, callback);
    } catch (e) {
      log.showError(`unregisterRssData faild, ${e}`)
    }
  }

  getRssData(resType: number, payload: Record<string, string>): Record<string, Object> | undefined {
    try {
      return sceneSessionManager.getRssData(resType, payload);
    } catch (e) {
      return undefined;
    }
  }
}

export class PcModeRSSUtils {
  public static readonly CAMERA_BUNDLE_NAME: string = 'com.ohos.camera';

  private static readonly RSS_DATA_PAYLOAD_MODE_FLOATING: string = 'FLOATING';

  private static readonly RSS_DATA_PAYLOAD_MODE_FULL_SCREEN: string = 'FULL_SCREEN';

  private static readonly SYNC_RES_TYPE_CHECK_APP_BEFORE_START: number = 501;

  private static readonly RSS_KEY_RESULT: string = 'result';

  private static readonly RSS_KEY_DETAILS: string = 'details';

  private static rssDataProvider: IRssDataProvider = new DefaultRssDataProvider();

  private static readonly rssDataCallbacks: Map<number, Callback<Record<string, string>, void>> = new Map();

  public static setRssDataProvider(provider: IRssDataProvider): void {
    PcModeRSSUtils.rssDataProvider = provider;
  }

  /**
   * start listening to rss mutex status
   */
  public static startListener(): void {
    for (const type of RSS_LISTEN_TYPE) {
      const callback = (data: Record<string, string>) => {
        PcModeRSSUtils.processRssData(type, data);
      }
      PcModeRSSUtils.rssDataCallbacks.set(type, callback);
      PcModeRSSUtils.rssDataProvider.registerRssData(type, callback);
    }
  }

  /**
   * Stop listening to the rss mutex status.
   */
  public static stopListener(): void {
    PcModeRSSUtils.rssDataCallbacks.forEach((value, key) => {
      PcModeRSSUtils.rssDataProvider.unregisterRssData(key, value);
    })
    PcModeRSSUtils.rssDataCallbacks.clear();
  }

  /**
   * processing Rss mutex data for floating scene
   * @param data
   */
  public static processRssData(listenerType: number, data: Record<string, string>): void {
    switch (listenerType) {
      case RSS_LISTEN_TYPE_MINIMIZE_FLOAT:
        const containerSessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager
          .getInstance().getContainerSessionList();
        for (const containerSession of containerSessionList) {
          const sceneInfo = containerSession.primarySession?.sceneInfo.bundleName;
          if (containerSession.primarySession?.sceneInfo.bundleName === PcModeRSSUtils.CAMERA_BUNDLE_NAME) {
            containerSession.requestBackground();
          }
        }
        break;
      default:
        log.showInfo(`unknown listener type ${listenerType}`);
        break;
    }
  }

  /**
   * 是否发生重载业务互斥
   * @param sceneInfo
   * @returns
   */
  public static isRssMutex(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      log.showError('sceneInfo is null or undefined');
      return false;
    }
    log.showInfo(`rss query scene: ${sceneInfo.bundleName}`);
    try {
      let payload: Record<string, string> =
        { 'bundleName': sceneInfo.bundleName,
          'mode': PcModeRSSUtils.RSS_DATA_PAYLOAD_MODE_FLOATING };
      let reply: ESObject = sceneSessionManager.getRssData(PcModeRSSUtils.SYNC_RES_TYPE_CHECK_APP_BEFORE_START, payload);
      let isMutex = Boolean(reply[PcModeRSSUtils.RSS_KEY_RESULT]);
      log.showInfo(`rss query result: ${isMutex}.`);
      return isMutex;
    } catch (e) {
      log.showError(`rss query faild, ${e}`);
      return false;
    }
  }
}