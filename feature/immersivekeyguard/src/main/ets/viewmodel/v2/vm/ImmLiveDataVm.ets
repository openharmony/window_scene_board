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

import { LiveNotification } from '@ohos/systemuicommon/newIndex';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { ImmDataShareWrap } from '../../../common/interface/IImmDataShare';
import { IImmersiveLiveTimerVm } from '../../../common/interface/IImmersiveLiveTimerVm';
import { IImmLiveDataVm } from '../../../common/interface/IImmLiveDataVm';
import { ImmersiveNtfBaseVm } from './ImmersiveNtfBaseVm';

/**
 * 沉浸模块实况数据管理器
 */
export class ImmLiveDataVm extends ImmersiveNtfBaseVm implements IImmLiveDataVm {
  // 全量实况数据集
  private readonly allLiveData: Map<string, LiveNotification> = new Map();

  // 是否开启子线程
  private readonly isSystemUIWorker: boolean = SystemUICcmConfig.instance.isEnabledWorker;

  init(): void {
  }

  destroy(): void {
    if (!this.isSystemUIWorker) {
      return;
    }
    this.clearLiveTimer();
    this.allLiveData.clear();
  }

  onDelWrongData(groupKey: string): void {
    if (!this.isSystemUIWorker) {
      return;
    }
    this.allLiveData.delete(groupKey);
  }

  onDataChange(dataShare: ImmDataShareWrap): void {
    // 未启用子线程时，计时器无需多余处理
    if (!this.isSystemUIWorker) {
      return;
    }
    if (!dataShare.isDataChange()) {
      return;
    }
    // 数据change集
    let isDel = dataShare.isDel();
    dataShare.getDataChangeArr()?.forEach((data) => {
      if (isDel) {
        this.onLiveDataDel(data);
        return;
      }
      // 区分新增、更新
      this.checkAddUpdate(data);
    });
    // 数据更新集
    dataShare.getDataUpdateArr()?.forEach((data) => {
      // 区分新增、更新
      this.checkAddUpdate(data);
    });
  }

  private clearLiveTimer(): void {
    // 清空实况计时器
    this.allLiveData.forEach((data) => this.getLiveTimerVm()?.deleteLiveTimer(data));
  }

  private checkAddUpdate(data?: NotificationBase): void {
    if (!data) {
      return;
    }
    let oldData = this.allLiveData.get(data.groupKey);
    if (oldData) {
      this.onLiveDataUpdate(oldData, data);
    } else {
      this.onLiveDataAdd(data);
    }
  }

  private onLiveDataAdd(addData?: NotificationBase): void {
    if (!addData || !addData.isLiveView()) {
      return;
    }
    this.allLiveData.set(addData.groupKey, addData);
    // 同步启动计时器
    this.getLiveTimerVm()?.setLiveTimer(addData);
  }

  private onLiveDataUpdate(oldData: LiveNotification, newData?: NotificationBase): void {
    this.allLiveData.delete(oldData.groupKey);
    if (!newData || !newData.isLiveView()) {
      // 从实况更新为非实况
      this.getLiveTimerVm()?.deleteLiveTimer(oldData);
      return;
    }
    // 实况更新实况
    this.allLiveData.set(newData.groupKey, newData);
    this.getLiveTimerVm()?.updateLiveTimer(newData, oldData);
    this.getLiveTimerVm()?.deleteLiveTimer(oldData, newData);
  }

  private onLiveDataDel(delData?: NotificationBase): void {
    if (!delData || !delData.isLiveView()) {
      return;
    }
    this.allLiveData.delete(delData.groupKey);
    // 删除计时器
    this.getLiveTimerVm()?.deleteLiveTimer(delData);
  }

  private getLiveTimerVm(): IImmersiveLiveTimerVm | undefined {
    return this.vmInjector?.getLiveTimerVm();
  }
}