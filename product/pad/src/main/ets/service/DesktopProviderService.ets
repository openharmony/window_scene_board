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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import type Want from '@ohos.app.ability.Want';
import type rpc from '@ohos.rpc';
import { BaseServiceStub, IService } from '@ohos/componenthelper';
import { Log } from '@ohos/basicutils';
import { RecentDeviceService } from '@ohos/phonebase/src/main/ets/service/RecentDeviceService';
// import { RestoringPhoneDesktopLayout } from '@ohos/phonebase/src/main/ets/backup/RestoringPhoneDesktopLayout';
import { SampleDeviceService } from '@ohos/pagedesktop/src/main/ets/default/service/SampleDeviceService';
import { DesktopIconService } from '@ohos/pagedesktop/src/main/ets/default/service/DesktopIconService';
import { GlobalSearchLocationService } from '@ohos/phonebase/src/main/ets/service/GlobalSearchLocationService';
import { CloneCloudService } from '@ohos/phonebase/src/main/ets/service/CloneCloudService';
import { QueryDesktopAppService } from '@ohos/phonebase/src/main/ets/service/QueryDesktopAppService';
import { ScenePerceptionService } from '@ohos/phonebase/src/main/ets/service/ScenePerceptionService';
import { AiSuggestionService } from '@ohos/aisuggestion';
import lazy DesktopProviderServiceProxy from '@ohos/pcbase/src/main/ets/service/DesktopProviderServiceProxy';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'DesktopProviderService';

/**
 * 桌面对外提供服务
 *
 * @since 2023-08-11
 */
export default class DesktopProviderService extends ServiceExtensionAbility {
  private readonly desktopProviderService = new PhoneDesktopProviderServiceStub(TAG);

  onCreate(want: Want): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      DesktopProviderServiceProxy.getInstance().onCreate(want);
      return;
    }
    Log.showInfo(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want, startId: number): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      DesktopProviderServiceProxy.getInstance().onRequest(want, startId);
      return;
    }
    Log.showInfo(TAG, `onRequest, want: ${want.abilityName}, startId: ${startId}`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    if (DeviceHelper.is2In1DevicePcType()) {
      return DesktopProviderServiceProxy.getInstance().onConnect(want);
    }
    Log.showInfo(TAG, `onConnect, want: ${want.abilityName} ${want.bundleName}`);
    return this.desktopProviderService;
  }

  onDisconnect(want: Want): void | Promise<void> {
    if (DeviceHelper.is2In1DevicePcType()) {
      return DesktopProviderServiceProxy.getInstance().onDisconnect(want);
    }
    Log.showInfo(TAG, `onDisconnect, want: ${want.abilityName}`);
    try {
      const actionLabel = want.action;
      if (!actionLabel) {
        return;
      }
      const code: number = Number(actionLabel.split('_').shift());
      if (isNaN(code)) {
        Log.showInfo(TAG, `code is NaN`);
      }
      const serviceMap = this.desktopProviderService.getServiceMap();
      const service = serviceMap.get(code);
      if (!service) {
        Log.showInfo(TAG, `not exist code: ${code}`);
        return;
      }
      service().onDisConnect?.(actionLabel);
    } catch (err) {
      Log.showInfo(TAG, `err: ${err}`);
    }
  }

  onDestroy(): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      return DesktopProviderServiceProxy.getInstance().onDestroy();
    }
    Log.showInfo(TAG, 'onDestroy');
  }
}

/**
 * 手机桌面对外提供服务映射 => 一个请求码对应一个业务方
 *
 * @since 2023-08-11
 */
export class PhoneDesktopProviderServiceStub extends BaseServiceStub {
  private static readonly aiSuggestion = 1;
  private static readonly cloneCloud = 2;
  private static readonly aiVassiant = 3;
  private static readonly sampleDevice = 4;
  private static readonly recentDeleteDeviece = 5;
  private static readonly globalSearch = 6;
  private static readonly desktopIcon = 7;
  private static readonly queryNotInstall = 8;
  private static readonly cloneCloudRawData = 9;
  private static readonly scenePerception = 10;
  protected getTag(): string {
    return 'PhoneDesktopProviderServiceStub';
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [PhoneDesktopProviderServiceStub.aiSuggestion, (): IService => new AiSuggestionService()],
      [PhoneDesktopProviderServiceStub.cloneCloud, (): IService => new CloneCloudService()],
      // [PhoneDesktopProviderServiceStub.sampleDevice,
      //   (): IService => new SampleDeviceService(new RestoringPhoneDesktopLayout())],
      [PhoneDesktopProviderServiceStub.recentDeleteDeviece, (): IService => new RecentDeviceService()],
      [PhoneDesktopProviderServiceStub.globalSearch, (): IService => new GlobalSearchLocationService()],
      [PhoneDesktopProviderServiceStub.queryNotInstall, (): IService => new QueryDesktopAppService()],
      [PhoneDesktopProviderServiceStub.desktopIcon, (): IService => new DesktopIconService()],
      [PhoneDesktopProviderServiceStub.cloneCloudRawData, (): IService => new CloneCloudService()],
      [PhoneDesktopProviderServiceStub.scenePerception, (): IService => new ScenePerceptionService()]
    ]);
  }
}
