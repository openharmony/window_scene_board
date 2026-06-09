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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { BaseVm } from '../../vm/BaseVm';
import { ILiveCapsuleLifecycleVm } from '../interface/ILiveCapsuleLifecycleVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';

const TAG = 'LiveCapsuleLifecycleVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况胶囊生命周期VM
 */
export class LiveCapsuleLifecycleVm extends BaseVm<LiveVmInjector> implements ILiveCapsuleLifecycleVm {
  private static readonly SEC_VAL: number = 1000;

  private lifeMap: Map<number, CapsuleLifecycleInfo> = new Map();

  /**
   * 获取胶囊的显示时间
   * @param id
   * @returns
   */
  getCapsuleShowTime(id: number): number {
    const totalKeepTime = this.lifeMap.get(id)?.totalKeepTime;
    if (!totalKeepTime) {
      return 0;
    }
    return totalKeepTime / LiveCapsuleLifecycleVm.SEC_VAL;
  }

  /**
   * 删除胶囊统计
   * @param id
   */
  deleteLifecycleInfo(id: number): void {
    this.lifeMap.delete(id);
    log.showInfo(`delete lifecycle info ${id}`);
  }

  /**
   * 更新胶囊的显隐状态，修改计时
   * @param liveList
   * @returns
   */
  async updateCapsuleShow(liveList: LiveNotification[]): Promise<void> {
    liveList.forEach(live => {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (capsuleVm.isShow) {
        // 胶囊显示计时
        this.startCountTime(live.id);
      } else {
        // 胶囊不显示，停止计时
        this.endCountTime(live.id);
      }
    });
  }

  private startCountTime(id: number): void {
    const lifecycleInfo = this.lifeMap.get(id) ?? new CapsuleLifecycleInfo();
    if (lifecycleInfo.isCounting) {
      return;
    }
    lifecycleInfo.capsuleStartTime = new Date().getTime();
    lifecycleInfo.isCounting = true;
    this.lifeMap.set(id, lifecycleInfo);

    log.showInfo(`id ${id}, start time is ${this.lifeMap.get(id)?.capsuleStartTime}`);
  }

  private endCountTime(id: number): void {
    const lifecycleInfo = this.lifeMap.get(id);
    if (lifecycleInfo?.isCounting) {
      const keepTime = new Date().getTime() - lifecycleInfo.capsuleStartTime;
      lifecycleInfo.totalKeepTime += keepTime;
      log.showInfo(`id ${id}, startTime ${lifecycleInfo.capsuleStartTime}, keepTime ${keepTime}, totalKeepTime ${lifecycleInfo.totalKeepTime}`);
      lifecycleInfo.capsuleStartTime = 0;
      lifecycleInfo.isCounting = false;
    }
  }
}

class CapsuleLifecycleInfo {
  /**
   * 胶囊总的出现时间
   */
  public totalKeepTime: number = 0;
  /**
   * 胶囊本次开始出现的时间点
   */
  public capsuleStartTime: number = 0;
  /**
   * 是否正在计时中
   */
  public isCounting: boolean = false;
}
