/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { FormStackSnapCommonData } from '../common/FormStackSnapCommonData';
import { FormStackSnapViewEvent } from '../viewmodel/FormStackSnapViewEvent';
import { FormStackSnapViewData } from '../viewmodel/FormStackSnapViewData';

const TAG: string = 'FormStackSnapView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormStackSnapView {
  private mCommonData: FormStackSnapCommonData = new FormStackSnapCommonData();
  private mEvent: FormStackSnapViewEvent = new FormStackSnapViewEvent();
  @State mViewData: FormStackSnapViewData = new FormStackSnapViewData();

  aboutToAppear(): void {
    log.showInfo('FormStackSnapView appear.');
    this.mEvent.initData(this.mViewData, this.mCommonData);
  }

  aboutToDisappear(): void {
    log.showInfo('FormStackSnapView disappear.');
    this.mEvent.resetData();
  }

  private buildLog(): boolean {
    log.showWarn('build formstack snap view.');
    return true;
  }

  build() {
    if (this.mViewData.mIsShow) {
      if (this.buildLog()) {}
      Image(ResourceManager.getInstance().getCachedCardSnapshot(this.mCommonData.mImgCacheKey))
        .draggable(false)
        .objectFit(ImageFit.Fill)
        .autoResize(false)
        .syncLoad(true)
        .interpolation(ImageInterpolation.Medium)
        .width(this.mCommonData.mWidth)
        .height(this.mCommonData.mHeight)
        .position({ x: this.mCommonData.mPosX, y: this.mCommonData.mPosY })
        .borderRadius(this.mCommonData.mBorderRadius)
    }
  }
}