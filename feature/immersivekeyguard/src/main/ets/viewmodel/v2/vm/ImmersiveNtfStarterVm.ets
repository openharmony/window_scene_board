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

import wantAgentController from '@ohos.app.ability.wantAgent';
import { LogDomain, Logger } from '@ohos/basicutils';
import { NotificationStarterVm } from '@ohos/notificationcomponent/newIndex';
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { NotificationStartWantAgentParams } from '@ohos/systemuicommon/newIndex';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { IImmersiveNtfStarterVm } from '../../../common/interface/IImmersiveNtfStarterVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';

const TAG = 'ImmersiveNtfStarterVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 沉浸列表条目点击启动业务管理
 */
@ObservedV2
export class ImmersiveNtfStarterVm extends NotificationStarterVm implements IImmersiveNtfStarterVm {
  // 通用注入器
  protected vmInjector: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.vmInjector = vmInjector;
  }

  startNtfWantAgent(ntf?: NotificationBase): void {
    if (!ntf) {
      return;
    }
    const groupNtf = this.vmInjector.getListVm()?.getGroupNtf(ntf);
    const groupCardVm = groupNtf ? this.vmInjector.getCardVm(groupNtf) : undefined;
    const cardVm = this.vmInjector?.getCardVm(ntf);

    // 启动WantAgent
    this.startWantAgent({
      groupNtf: groupNtf,
      groupCardVm: groupCardVm,
      cardVm: cardVm,
      wantAgent: ntf.wantAgent,
      wantAgentInfo: ntf.wantAgentInfo,
      triggerInfo: { code: 0 },
    });
  }

  async startWantAgent(params: NotificationStartWantAgentParams): Promise<void> {
    try {
      Promise.all([
        wantAgentController.getOperationType(params.wantAgent)
      ]).then((res: [number]) => {
        const operType = res[0];
        log.showInfo(TAG, `startWantAgent, operType is ${operType}`);
        const isAbility = Boolean(operType !== wantAgentController.OperationType.SEND_COMMON_EVENT);
        if (!isAbility && params.operationInfo) {
          super.startWantAgent(params);
        } else {
          ScreenLockApi.requestUnlock({
            success: () => {
              super.startWantAgent(params);
            }
          });
        }
      }).catch((err: Error) => {
        log.showError(TAG, `startWantAgent, getOperationType error, ntf hashcode is ${params.groupNtf?.hashCode}`);
      });
    } catch (err) {
      log.showError(TAG, `startWantAgent, try-catch error, ntf hashcode is ${params.groupNtf?.hashCode}`);
    }
  }

  /**
   * 锁屏通知跳转应用时, 不使用通知中心启动应用一镜到底动效
   */
  isStartAppByOneMirror(params: NotificationStartWantAgentParams): boolean {
    return false;
  }
}