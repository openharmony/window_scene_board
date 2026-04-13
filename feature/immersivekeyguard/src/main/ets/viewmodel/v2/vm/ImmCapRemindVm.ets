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

import { LogDomain, Logger } from '@ohos/basicutils';
import { CapAnimScene, CapShowType } from '../../../common/constants/ImmCapConst';
import { IImmCapRemindVm } from '../../../common/interface/IImmCapRemindVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { ImmCapDataArray } from '../../../model/data/v2/ImmCapDataArray';
import { SlCapBindStateV2 } from '../../../model/data/v2/SlCapBindStateV2';

const TAG = 'ImmCapRemindVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 胶囊强提醒退出倒计时时长
const CAP_REMIND_DURATION: number = 5000;

// 强提醒检测参数
interface RemindParam {
  // 是否强提醒倒计时中
  isCountDown: boolean;
  // 是否胶囊状态
  isCapState: boolean;
  // 是否AOD状态
  isAodState: boolean;
  // 强提醒胶囊是否动效中
  isRemindStAnim: boolean;
}

/**
 * 沉浸胶囊强提醒业务管理
 */
export class ImmCapRemindVm implements IImmCapRemindVm {
  // 通用注入器
  private readonly vmInjector: IImmersiveNtfVmInjector;

  // 强提醒检测参数
  private readonly remindParam: RemindParam = {isCountDown: false, isCapState: false,
    isAodState: false, isRemindStAnim: false};

  // 是否已开启强提醒
  private isStartRemind: boolean = false;

  // 强提醒退出倒计时ID
  private remindExitId?: number;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
  }

  /**
   * 强提醒翻转动效启动回调
   */
  public onRemindAnimStart(): void {
    // 开启倒计时
    this.startRemindTimeout();
    this.checkCapRemindChange(true);
  }

  /**
   * 当前沉浸状态是否为胶囊态状态切换
   *
   * @param isCapState true胶囊态
   */
  public onCapStateChange(isCapState: boolean): void {
    if (this.remindParam.isCapState === isCapState) {
      return;
    }
    this.remindParam.isCapState = isCapState;
    if (isCapState) {
      return;
    }
    // 切换其他状态时，及时清除倒计时，延时检测，避免影响过渡动效
    if (this.endRemindTimeout()) {
      const delayId = setTimeout(() => {
        clearTimeout(delayId);
        this.checkCapRemindChange();
      });
    }
  }

  /**
   * 当前状态是否为AOD状态切换
   *
   * @param isAodState true AOD
   */
  public onAodStateChange(isAodState: boolean): void {
    if (this.remindParam.isAodState === isAodState) {
      return;
    }
    this.remindParam.isAodState = isAodState;
    if (!isAodState) {
      return;
    }
    // AOD状态，及时清除倒计时
    if (this.endRemindTimeout()) {
      this.checkCapRemindChange();
    }
  }

  /**
   * 强提醒胶囊动效状态切换
   *
   * @param isAnimating true动效中
   */
  public onRemindAnimStChange(isAnimating?: boolean): void {
    let result = isAnimating ?? false;
    if (this.remindParam.isRemindStAnim === result) {
      return;
    }
    this.remindParam.isRemindStAnim = result;
    // 退出动效时，检测是否可以退出强提醒
    if (!result) {
      this.checkCapRemindChange();
    }
  }

  private checkCapRemindChange(isForceRemind: boolean = false): void {
    // 检测强提醒状态切换
    let result = isForceRemind ? isForceRemind : this.isCapRemindState();
    if (this.isStartRemind !== result) {
      this.isStartRemind = result;
      // 通知强提醒状态切换
      this.getCapBindSt()?.setCapRemind(result);
      // 检测启动强提醒退出动效
      this.checkCapRemindExitAnim();
    }
  }

  // 检测胶囊强提醒退出动效
  private checkCapRemindExitAnim(): void {
    // 强提醒状态，不涉及退出动效
    if (this.isStartRemind) {
      return;
    }
    // 非胶囊态或AOD状态，直接退出强提醒，不做动效
    if (!this.remindParam.isCapState || this.remindParam.isAodState) {
      this.getCapData()?.remove(CapShowType.CAP_REMIND);
      log.showInfo(TAG, 'checkCapRemindExitAnim exit direct.');
      return;
    }
    // 开启强提醒退出动效
    let remindExitAnim = this.vmInjector?.getCapLifeCycleAnimFactory()?.createImmAnim(CapAnimScene.ANIM_REMIND_EXIT);
    remindExitAnim?.onLifeCycleAnim();
    log.showInfo(TAG, 'checkCapRemindExitAnim start remind exit anim.');
  }

  private isCapRemindState(): boolean {
    // 强提醒倒计时中，保持强提醒状态
    if (this.remindParam.isCountDown) {
      return this.isStartRemind;
    }
    // 倒计时已结束，等待动效结束
    if (this.remindParam.isRemindStAnim) {
      return this.isStartRemind;
    }
    return false;
  }

  private startRemindTimeout(): void {
    this.endRemindTimeout();
    this.remindParam.isCountDown = true;
    this.remindExitId = setTimeout(() => {
      // 检测强提醒切换
      if (this.endRemindTimeout()) {
        this.checkCapRemindChange();
      }
    }, CAP_REMIND_DURATION);
  }

  private endRemindTimeout(): boolean {
    if (this.remindExitId) {
      clearTimeout(this.remindExitId);
      this.remindExitId = undefined;
    }
    if (this.remindParam.isCountDown) {
      this.remindParam.isCountDown = false;
      return true;
    }
    return false;
  }

  private getCapData(): ImmCapDataArray | undefined {
    return this.vmInjector?.getImmersiveCapVm()?.getSlCapData();
  }

  private getCapBindSt(): SlCapBindStateV2 | undefined {
    return this.vmInjector?.getImmersiveCapVm()?.getSlBindState();
  }
}