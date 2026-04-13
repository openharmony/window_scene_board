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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { Singleton, ThreadSync } from '@ohos/systemuicommon/newTsIndex';

const TAG = 'ScreenTitleBarVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
@ThreadSync.VmDecorator
@Observed
export class ScreenTitleBarVm {
  @Singleton.decorate()
  public static get instance(): ScreenTitleBarVm { return new ScreenTitleBarVm(); }
  public threadSyncName = 'ScreenTitleBarVm';
  constructor() {
  }

  // 全屏titlebar是否展示
  public isShowFullScreenTitleBar: boolean = false;

  public init(): void {
    log.showInfo('init');
    SCBSceneSessionManager.getInstance().registerFullScreenTitleBarAppearCallback(() => {
      log.showInfo('registerFullScreenTitleBarAppearCallback');
      this.isShowFullScreenTitleBar = true;
    });
    SCBSceneSessionManager.getInstance().registerHotRegionStateChangeCallback(() => {
      log.showInfo('registerHotRegionStateChangeCallback');
      this.isShowFullScreenTitleBar = false;
    });

  }

  /**
   * 去初始化状态栏背景vm
   */
  public unInit(): void {
    log.showInfo('unInit');
  }
}