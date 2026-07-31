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

import type Want from '@ohos.app.ability.Want';
import type rpc from '@ohos.rpc';
import type { IService } from '@ohos/componenthelper';
import { BaseServiceStub } from '@ohos/componenthelper';
import { Log } from '@ohos/basicutils';
import { DesktopIconService } from '@ohos/pagedesktop/src/main/ets/default/service/DesktopIconService';
import { HosKeyService } from './hosKey/HosKeyService';
import { RpcShutdownService } from './rpcShutdown/RpcShutdownService';
import { CloneCloudService } from './CloneCloudService';
import { SampleDeviceService } from '@ohos/pagedesktop/src/main/ets/default/service/SampleDeviceService';
// import { RestoringPcDesktopLayout } from '../backup/RestoringPcDesktopLayout';
import { FileFolderService } from '@ohos/desktopfilefolder';

const TAG = 'DesktopProviderServiceProxy';

/**
 * 桌面对外提供服务
 *
 * @since 2025-05-15
 */
export default class DesktopProviderServiceProxy {
  private static mInstance: DesktopProviderServiceProxy;

  public static getInstance(): DesktopProviderServiceProxy {
    if (!DesktopProviderServiceProxy.mInstance) {
      DesktopProviderServiceProxy.mInstance = new DesktopProviderServiceProxy();
    }
    return DesktopProviderServiceProxy.mInstance;
  }

  private readonly desktopProviderService = new DesktopProviderServiceStub(TAG);

  onCreate(want: Want): void {
    Log.showInfo(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want, startId: number): void {
    Log.showInfo(TAG, `onRequest, want: ${want.abilityName}, startId: ${startId}`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    Log.showInfo(TAG, `onConnect, want: ${want.abilityName} ${want.bundleName}`);
    return this.desktopProviderService;
  }

  onDisconnect(want: Want): void | Promise<void> {
    Log.showInfo(TAG, `onDisconnect, want: ${want.abilityName}`);
    try {
      let actionLabel = want.action;
      if (!actionLabel) {
        return;
      }
      const code: number = Number(actionLabel.split('_').shift());
      if (isNaN(code)) {
        Log.showInfo(TAG, `code is NaN`);
      }
      let serviceMap = this.desktopProviderService.getServiceMap();
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
    Log.showInfo(TAG, 'onDestroy');
  }
}

/**
 * pc桌面对外提供服务映射 => 一个请求码对应一个业务方
 *
 * @since 2024-03-11
 */
class DesktopProviderServiceStub extends BaseServiceStub {
  private static readonly systemKey = 2;
  private static readonly rpcShutdownKey = 3;
  private static readonly cloneCloud = 4;
  private static readonly sampleDevice = 5;
  private static readonly desktopIcon = 7;
  private static readonly scenePerception = 10;
  private static readonly filerFolderService= 11;

  constructor(des: string) {
    super(des);
    Log.showInfo(TAG, 'DesktopProviderServiceStub constructor');
  }

  protected getTag(): string {
    return 'DesktopProviderServiceStub';
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [DesktopProviderServiceStub.cloneCloud, (): IService => new CloneCloudService()],
      [DesktopProviderServiceStub.systemKey, (): IService => new HosKeyService()],
      [DesktopProviderServiceStub.rpcShutdownKey, (): IService => new RpcShutdownService()],
      [DesktopProviderServiceStub.desktopIcon, (): IService => new DesktopIconService()],
      [DesktopProviderServiceStub.filerFolderService, (): IService => new FileFolderService()],
      // [DesktopProviderServiceStub.sampleDevice,
      //   (): IService => new SampleDeviceService(new RestoringPcDesktopLayout())],
    ]);
  }
}