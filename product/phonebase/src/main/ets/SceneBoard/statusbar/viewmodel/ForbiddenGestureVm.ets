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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ForbiddenGestureSwitchEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { Singleton, ThreadSync } from '@ohos/systemuicommon/newTsIndex';

const TAG = 'ForbiddenGestureVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ThreadSync.VmDecorator
@Observed
export class ForbiddenGestureVm {
  @Singleton.decorate()
  public static get instance(): ForbiddenGestureVm { return new ForbiddenGestureVm(); }
  public threadSyncName = 'ForbiddenGestureVm';
  constructor() {
  }
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 防误触是否开启
   */
  private isForbiddenGesture?: boolean
  /**
   * 防误触开关
   */
  private onForbiddenGestureChange = (event: ForbiddenGestureSwitchEvent): void => {
    let isEnable = event.isForbiddenGestureSwitchEnable();
    log.showInfo(`onForbiddenGestureChange ${isEnable}`);
    this.isForbiddenGesture = isEnable;
  }

  isForbiddenGestureEnable(): boolean {
    return this.isForbiddenGesture ?? false;
  }

  public init(): void {
    this.eventMgr.on(ForbiddenGestureSwitchEvent, this.onForbiddenGestureChange);
    log.showInfo('init');
  }

  /**
   * 去初始化状态栏背景vm
   */
  public unInit(): void {
    log.showInfo('unInit');
    this.eventMgr.offAll();
  }
}