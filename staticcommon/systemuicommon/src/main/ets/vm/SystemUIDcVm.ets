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

import { Singleton } from '../utils/Singleton';
import { worker } from '@kit.ArkTS';
import { systemUIWorkerManager } from '../manager/SystemUIWorkerManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import DropDownPanelManager from '../manager/DropDownPanelManager';
import { EnvVm } from './EnvVm';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';
import { messageChannel } from '../messageChannel/MessageChannel';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'SystemUIDcVm');

/**
 * DC管理ViewModel
 */
@ObservedV2
export class SystemUIDcVm {
  @Singleton.decorate()
  static get instance() {
    return new SystemUIDcVm();
  }

  /**
   * 是否显示DC组件
   */
  @Trace public isShowDcEntry: boolean = false;
  /**
   * 是否显示下拉面板组件
   */
  @Trace public isShowDropdown: boolean = false;
  /**
   * 是否显示横幅/实况banner组件
   */
  @Trace public isShowBanner: boolean = false;

  constructor() {
    log.showInfo(`SystemUIDcVm init`);

    if (systemUIWorkerManager.tid !== undefined) {
      // worker已经加载，使能DC入口
      this.isShowDcEntry = true;
    }

    // 注册worker ready回调
    systemUIWorkerManager.emitter.on('workerReady', () => {
      log.showInfo(`workerReady`);
      // 使能DC入口
      this.isShowDcEntry = true;
    });

    // 注册状态栏 ready回调
    messageChannel.onMessage('statusBarReady', () => {
      log.showInfo(`statusBarReady`);
      // 加载下拉面板DC
      this.isShowDropdown = true;
    });

    // 注册下拉面板 ready回调
    messageChannel.onMessage('dropdownReady', () => {
      log.showInfo(`dropdownReady`);
      // 加载横幅DC
      this.isShowBanner = true;
    });

    // 注册横幅面板 ready回调
    messageChannel.onMessage('bannerReady', () => {
      log.showInfo(`bannerReady`);

      systemUIWorkerManager.initWatchDogTimer();
    });

    // 注册worker异常回调
    systemUIWorkerManager.emitter.on('workerErr', () => {
      // 删除原DC节点
      this.isShowDcEntry = false;
      this.isShowDropdown = false;
      this.isShowBanner = false;

      // 主线程 收起dropdown面板的WindowScene，避免残留遮住桌面
      DropDownPanelManager.hideWindowDirectly();
      // TODO: 收起banner面板的WindowScene
      EnvVm.instance.clear();
    });
  }

  /**
   * 获取worker实例
   * @returns
   */
  public getWorker(): worker.ThreadWorker | undefined {
    return systemUIWorkerManager.workerThread;
  }
}