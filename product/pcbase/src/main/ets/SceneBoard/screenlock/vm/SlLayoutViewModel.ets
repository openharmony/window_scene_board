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
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { SlLayoutData, VirtualScreenSize } from './SlLayoutData';

const TAG = 'ScreenLock-SlLayoutViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SlLayoutViewModel {
  private slLayoutData: SlLayoutData;

  constructor(viewData: SlLayoutData) {
    this.slLayoutData = viewData;
    if (!this.initViewModel()) {
      log.showWarn('ScreenLock layout VM init fail');
    }
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropChangeCallback);
  }

  private screenPropChangeCallback = (screenProp: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`update ScreenLock layout reason: ${reason}, ` +
      `screen number: ${SCBScreenSessionManager.getInstance().getScreenSessionList().length}`);
    // 只有屏幕实际转换的vp尺寸发生变化时，需要重新刷新锁屏布局
    if (this.isVirtualScreenSizeChanged(screenProp)) {
      log.showInfo('No need fresh ScreenLock layout');
      this.slLayoutData.mainScreenProp = screenProp;
      return;
    }
    this.slLayoutData.updateData();
  }

  private isVirtualScreenSizeChanged(nextScreenProp: SCBScreenProperty): boolean {
    const nextVirtualScreenSize: VirtualScreenSize = new VirtualScreenSize(nextScreenProp);
    return nextVirtualScreenSize.isEqual(this.slLayoutData.vScreenSize);
  }

  public initViewModel(): boolean {
    if (!this.slLayoutData.updateData()) {
      log.showWarn('ScreenLock layout data update fail');
      return false;
    }
    return true;
  }

  public updateAccountTopMargin(offsetGridNum: number): void {
    this.slLayoutData.updateAccountTopMargin(offsetGridNum);
  }

  public destroy(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropChangeCallback);
  }
}