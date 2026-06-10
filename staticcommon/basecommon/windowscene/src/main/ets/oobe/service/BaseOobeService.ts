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
import type { IService } from './BaseServiceStub';
import { BaseServiceStub } from './BaseServiceStub';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { OobeTrustListService } from './OobeTrustListService';

const TAG = 'BaseOobeService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 开机向导(OOBE)对外提供服务
 */
export class BaseOobeService extends ServiceExtensionAbility {
  private readonly oobeService = new OobeServiceStub(TAG);

  public onCreate(want: Want): void {
    log.info(`onCreate, want: ${want?.abilityName}`);
  }

  public onRequest(want: Want, startId: number): void {
    log.info(`onRequest, want: ${want?.abilityName}, startId: ${startId}`);
  }

  public onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    log.info(`onConnect, want: ${want?.abilityName} ${want?.bundleName}`);
    return this.oobeService;
  }

  public onDisconnect(want: Want): void | Promise<void> {
    if (CheckEmptyUtils.isEmpty(want)) {
      log.error('onDisconnect, want is empty');
      return;
    }
    log.info(`onDisconnect, want: ${want?.abilityName}`);
    try {
      let actionLabel = want?.action;
      if (actionLabel === undefined || actionLabel == null || actionLabel === '') {
        log.warn('onDisconnect, invalid action label');
        return;
      }
      const code: number = Number(actionLabel.split('_').shift());
      if (Number.isNaN(code)) {
        log.error('code is NaN');
        return;
      }
      let serviceMap = this.oobeService.getServiceMap();
      const serviceCreator = serviceMap.get(code);
      if (!serviceCreator) {
        log.error(`service not exist code: ${code}`);
        return;
      }
      const service = serviceCreator();
      if (!service.onDisconnect) {
        log.error('service no onDisconnect');
        return;
      }
      service.onDisconnect(actionLabel);
    } catch (error) {
      log.error(`Failed to onDisconnect. Code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public onDestroy(): void {
    log.info('onDestroy');
  }
}

/**
 * OOBE内服务请求码
 */
enum OobeServiceCode {
  // OOBE 信任列表管理服务
  trustList = 1,
}

/**
 * 开机向导(OOBE)对外提供服务映射 => 一个请求码对应一个业务方
 */
class OobeServiceStub extends BaseServiceStub {
  public constructor(des: string) {
    super(des);
    log.info('Constructor');
  }

  protected getTag(): string {
    return 'OobeServiceStub';
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [OobeServiceCode.trustList, (): IService => new OobeTrustListService()],
    ]);
  }
}