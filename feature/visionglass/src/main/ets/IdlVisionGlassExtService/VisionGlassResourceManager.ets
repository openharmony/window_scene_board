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

import {
  ResultBooleanCallback,
  GetVisionGlassAppListCallBack,
} from './IIdlVisionGlassExtService';
import type { BusinessError } from '@ohos.base';
import IdlVisionGlassExtServiceProxy from './IdlVisionGlassExtServiceProxy';
import { VisionGlassExtServiceCallbackStub } from './callback/VisionGlassExtServiceCallbackStub';
import { Want } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG: string = 'VisionGlassResourceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
type Param = GetVisionGlassAppListCallBack | ResultBooleanCallback;
type OnFail = () => void;
type Func = (param?: Param) => void;

export interface VisionGlassExtServiceEventListener {
  onEventChange(event: string, data: string): Promise<string | undefined>;
}

/**
 * VisionGlass resource manager, get app list etc. from VisionGlass app through VisionGlassExtService
 */
export class VisionGlassResourceManager {
  private static readonly SCB_BUNDLE_NAME: string = 'com.ohos.sceneboard';
  private static readonly VISION_GLASS_BUNDLE_NAME: string = 'com.ohos.visionglass';
  private static readonly VISION_GLASS_MODULE_NAME: string = 'entry';
  private static readonly VISION_GLASS_ABILITY_NAME: string = 'VisionGlassExtService';
  private isIdlConnecting: boolean = false;
  private idlSuccessCallbacks: (() => void)[] = [];
  private idlFailCallbacks: (() => void)[] = [];

  private static want: Want = {
    bundleName: this.VISION_GLASS_BUNDLE_NAME,
    abilityName: this.VISION_GLASS_ABILITY_NAME,
  };

  private static instance: VisionGlassResourceManager | undefined | null = undefined;

  private visionGlassExtServiceProxy: IdlVisionGlassExtServiceProxy | undefined | null = null;

  private connectId: number = 0;

  private visionGlassExtServiceEventListener: VisionGlassExtServiceEventListener | undefined | null = null;

  private serviceCallbackStub: VisionGlassExtServiceCallbackStub | undefined = new VisionGlassExtServiceCallbackStub(
    async (event: string, data: string) => {
      return await this.visionGlassExtServiceEventListener?.onEventChange(event, data);
    });

  /*
   * 获取当前资源管理类单实例
   *
   * @param VisionGlassResourceManager
   * */
  public static getInstance(): VisionGlassResourceManager {
    if (!VisionGlassResourceManager.instance) {
      log.showInfo(`getInstance new instance`);
      VisionGlassResourceManager.instance = new VisionGlassResourceManager();
    }
    return VisionGlassResourceManager.instance;
  }

  public static release(): void {
    VisionGlassResourceManager.instance?.destroy();
    log.showInfo(`release`);
    VisionGlassResourceManager.instance = undefined;
  }

  /**
   * Init single instance. connect VisionGlassExtService
   */
  public init(): void {
    log.showInfo('init');
    this.connectServiceExtensionAbility();
  }

  private connectServiceExtensionAbility(
    func: Func | undefined = undefined,
    onFail: OnFail | undefined = undefined,
    param: Param | undefined = undefined): void {
    if (func !== undefined) {
      this.idlSuccessCallbacks.push(() => func(param));
    }
    if (onFail !== undefined) {
      this.idlFailCallbacks.push(() => onFail());
    }
    if (this.isIdlConnecting) {
      log.showInfo('idl is connecting, wait result');
      return;
    }
    this.isIdlConnecting = true;
    this.connectId = GlobalContext.getContext().connectServiceExtensionAbility(VisionGlassResourceManager.want,
      {
        onConnect: (elementName, proxy) => {
          log.showInfo(`onConnect ${elementName.abilityName}`);
          this.visionGlassExtServiceProxy = new IdlVisionGlassExtServiceProxy(proxy);
          this.handleCallbacksOnConnected();
          this.visionGlassExtServiceProxy.register(VisionGlassResourceManager.SCB_BUNDLE_NAME, this.serviceCallbackStub,
            error => {
              log.showError(`register callback, code: ${error}`);
            });
        },
        onDisconnect: (elementName) => {
          log.showInfo(`onDisconnect ${elementName.abilityName}`);
          this.isIdlConnecting = false;
          this.visionGlassExtServiceProxy?.unRegister(VisionGlassResourceManager.SCB_BUNDLE_NAME, (error) => {
            log.showError(`unRegister callback, code: ${error}`);
          });
          this.visionGlassExtServiceProxy = undefined;
        },
        onFailed: (code) => {
          log.showError(`onFailed ${code}`);
          this.handleCallbacksOnFailed();
        }
      });
    log.info(`connect VisionGlassService id is ${this.connectId}`);
  }

  /**
   * Destroy single instance
   */
  private destroy(): void {
    log.showInfo(`destroy, id is ${this.connectId}`);
    this.visionGlassExtServiceEventListener = undefined;
    GlobalContext.getContext().disconnectServiceExtensionAbility(this.connectId).then(() => {
      log.showInfo('disconnect succeed.');
    }).catch((error: BusinessError) => {
      log.showError(`disconnect failed. Error code: ${error.code}`);
    });
    this.resetIdlCallbacks();
    this.serviceCallbackStub?.release();
    this.serviceCallbackStub = undefined;
  }

  private handleCallbacksOnConnected(): void {
    this.isIdlConnecting = false;
    this.idlSuccessCallbacks.forEach(callback => {
      callback();
    });
    this.resetIdlCallbacks();
  }

  private handleCallbacksOnFailed(): void {
    this.isIdlConnecting = false;
    this.idlFailCallbacks.forEach(callback => {
      callback();
    });
    this.resetIdlCallbacks();
  }

  private resetIdlCallbacks(): void {
    this.idlSuccessCallbacks = [];
    this.idlFailCallbacks = [];
  }

  public registerVisionGlassExtServiceEventListener(listener: VisionGlassExtServiceEventListener): void {
    this.visionGlassExtServiceEventListener = listener;
  }

  public sendActiveWant(data: string): void {
    if (this.visionGlassExtServiceProxy) {
      this.visionGlassExtServiceProxy.sendActiveWant(data);
      return;
    }
    log.showInfo('sendActiveWant, VisionGlassExtService is not connected, startConnect');
    this.connectServiceExtensionAbility(() => this.sendActiveWant(data));
  }

  public async saveImage(imageName: string, packImage: ArrayBuffer): Promise<number | undefined> {
    return this.visionGlassExtServiceProxy?.saveImage(imageName, packImage);
  }

  public async changePointerVisible(isVisible: boolean): Promise<void> {
    await this.visionGlassExtServiceProxy?.changePointerVisible(isVisible);
  }

  public showRightDialogOnPhone(): void {
    this.visionGlassExtServiceProxy?.showRightDialogOnPhone();
  }
}
