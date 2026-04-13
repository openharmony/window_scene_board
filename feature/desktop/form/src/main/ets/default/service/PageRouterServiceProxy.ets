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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import type Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PageRouterServiceCode } from '@ohos/commonconstants';
import { BaseServiceStub } from '@ohos/componenthelper';
import type { IService } from '@ohos/componenthelper';
import { FormManageRouterService } from './FormManageRouterService';
import { FormEditRouterService } from './FormEditRouterService';
import { LiveFormRouterService } from './LiveFormRouterService';
import { FormConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { IRequestService } from '@ohos/componenthelper/src/main/ets/utils/BaseServiceStub';

const TAG = 'PageRouterServiceProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export interface ServiceMapConfig {
  isFormManagerEnabled?: boolean,
  isFormEditEnabled?: boolean,
  isLiveFormEnabled?: boolean,
}

export class PageRouterServiceProxy extends ServiceExtensionAbility {
  private readonly mRouterService: PageRouterServiceStub = new PageRouterServiceStub(TAG);

  private static mInstance: PageRouterServiceProxy;
  public static getInstance(): PageRouterServiceProxy {
    if (!PageRouterServiceProxy.mInstance) {
      PageRouterServiceProxy.mInstance = new PageRouterServiceProxy();
    }
    return PageRouterServiceProxy.mInstance;
  }

  protected getRouterRequestService(): PageRouterRequestService {
    let serviceMapConfig: ServiceMapConfig = {
      isFormManagerEnabled: this.isFormManagerEnabled(),
      isFormEditEnabled: this.isFormEditEnabled(),
      isLiveFormEnabled: this.isLiveFormEnabled(),
    }
    return PageRouterRequestService.getInstance(serviceMapConfig);
  }

  protected isFormManagerEnabled(): boolean {
    return true;
  }

  protected isFormEditEnabled(): boolean {
    return true;
  }

  protected isLiveFormEnabled(): boolean {
    return true;
  }

  onCreate(want: Want): void {
    log.showInfo(`onCreate, want: ${want?.abilityName}.`);
  }

  onRequest(want: Want, startId: number): void {
    this.getRouterRequestService().onRequest(want);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.showInfo(`onConnect, want: ${want?.abilityName} ${want?.bundleName}.`);
    return this.mRouterService;
  }

  onDisconnect(want: Want): void | Promise<void> {
    log.showInfo(`onDisconnect, want: ${want?.abilityName}.`);
  }

  onDestroy(): void {
    log.showInfo('onDestroy.');
  }
}

/**
 * 桌面的Page Router服务对外提供服务映射 => 一个请求码对应一个业务方
 */
export class PageRouterServiceStub extends BaseServiceStub {
   getTag(): string {
    return 'PageRouterServiceStub';
  }

  public async onRemoteMessageRequest(
    code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    option: rpc.MessageOption
  ): Promise<boolean> {
    let isGranted: boolean = this.checkPermissions();
    if (!isGranted) {
      log.showError('permission denied');
      return false;
    }
    let baseCheck: boolean = await super.onRemoteMessageRequest(code, data, reply, option);
    return baseCheck;
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [PageRouterServiceCode.FORM_MANAGE, (): IService => new FormManageRouterService()],
    ]);
  }

  private checkPermissions(): boolean {
    try {
      let callerTokenId: number = rpc.IPCSkeleton.getCallingTokenId();
      let atManger: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      let requireFormGrant: abilityAccessCtrl.GrantStatus =
        atManger.verifyAccessTokenSync(callerTokenId, 'ohos.permission.REQUIRE_FORM');
      let startUiGrant: abilityAccessCtrl.GrantStatus =
        atManger.verifyAccessTokenSync(callerTokenId, 'ohos.permission.START_DESKTOP_UI_COMPONENT');

      if (requireFormGrant === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED &&
        startUiGrant === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        return false;
      }
    } catch (err) {
      log.showError(`check caller fail because ${err?.code}`);
      return false;
    }
    return true;
  }
}

export class PageRouterRequestService {
  private static mInstance: PageRouterRequestService;
  private readonly serviceMap: Map<number, () => IRequestService> = new Map();

  public static getInstance(config: ServiceMapConfig): PageRouterRequestService {
    if (PageRouterRequestService.mInstance == null) {
      PageRouterRequestService.mInstance = new PageRouterRequestService();
    }
    PageRouterRequestService.mInstance.updateServiceMap(config);
    return PageRouterRequestService.mInstance;
  }

  onRequest(want: Want): void {
    if (CheckEmptyUtils.isEmpty(want)) {
      log.showError(`onRequest, want is empty!`);
      return;
    }

    log.showWarn(`PhonePageRouterRequestService want. abilityName: ${want?.abilityName} action: ${want?.action}`);
    if (want.action === FormConstants.ACTION_FORM_PAGE) {
      const mPageRouterServiceCode: number | undefined = Number(want.parameters?.pageRouterServiceCode);
      if (typeof mPageRouterServiceCode === 'undefined') {
        log.showError(`onRequest, mPageRouterServiceCode is undefined!`);
        return;
      }

      const mService: (() => IRequestService) | undefined = this.serviceMap.get(mPageRouterServiceCode);
      if (!mService) {
        log.showError(`onRequest, mService is undefined!`);
        return;
      }
      mService().onRequest(want);
    }
  }

  protected updateServiceMap(config: ServiceMapConfig): void {
    this.serviceMap.clear();
    if (config.isFormManagerEnabled) {
      this.serviceMap.set(PageRouterServiceCode.FORM_MANAGE, (): IRequestService => new FormManageRouterService());
    }

    if (config.isFormEditEnabled) {
      this.serviceMap.set(PageRouterServiceCode.FORM_EDIT, (): IRequestService => new FormEditRouterService());
    }

    if (config.isLiveFormEnabled) {
      this.serviceMap.set(PageRouterServiceCode.LIVE_FORM, (): IRequestService => new LiveFormRouterService());
    }
  }
}