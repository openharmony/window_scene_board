/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import { DropAnimationScene } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackSnapCommonData } from '../common/FormStackSnapCommonData';
import { FormStackSnapViewData } from '../viewmodel/FormStackSnapViewData';
import { formStackSnapShowManager } from '../common/FormStackSnapShowManager';
import { FormStackUtil } from '../common/FormStackUtil';

const TAG: string = 'FormStackSnapViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

type FormStackShowMsgCb = (isShow: boolean, commonData?: FormStackSnapCommonData) => void;

export class FormStackSnapViewEvent {
  public mViewData?: FormStackSnapViewData;
  public mCommonData?: FormStackSnapCommonData;
  private mFormStackShowMsgCb: FormStackShowMsgCb = (isShow: boolean, commonData?: FormStackSnapCommonData) =>
    this.onRecvSnapShowMsg(isShow, commonData);

  public initData(viewData: FormStackSnapViewData, commonData: FormStackSnapCommonData): void {
    this.mViewData = viewData;
    // mCommonData关联了视图数据引用传递，不可随意重置指向对象
    this.mCommonData = commonData;

    GlobalContext.getContext()?.eventHub.on(FormStackConstants.FORM_STACK_SNAP_SHOW_MSG, this.mFormStackShowMsgCb);
    log.showInfo('init data success.');
  }

  public resetData(): void {
    log.showInfo('resetData enter.');
    this.mViewData = undefined;
    this.mCommonData = undefined;
    GlobalContext.getContext()?.eventHub.off(FormStackConstants.FORM_STACK_SNAP_SHOW_MSG, this.mFormStackShowMsgCb);
  }

  public onRecvSnapShowMsg(isShow: boolean, commonData?: FormStackSnapCommonData): void {
    log.showWarn(`recv form snap show msg, isShow: ${isShow}.`);
    if (!isShow) {
      // 销毁遮罩截图组件
      this.clearSnapshotData();
      return;
    }

    if (!this.mViewData || !this.mCommonData || !commonData) {
      log.showError('handle onRecvSnapShowMsg failed, mViewData or mCommonData is invalid!');
      return;
    }

    if (!ResourceManager.getInstance().getCachedCardSnapshot(commonData?.mImgCacheKey)) {
      log.showError(`handle onRecvSnapShowMsg failed, can not find cache pixmap by key: ${commonData?.mImgCacheKey}!`);
      return;
    }

    this.mCommonData.copy(commonData);
    this.mViewData.mIsShow = true;
    log.showWarn(`show snap img, commonData: ${this.mCommonData.toString()}.`);

    // 截图延时自销毁
    setTimeout(() => {
      if (!this.mViewData?.mIsShow) {
        return;
      }
      log.showWarn('snap view show time out.');
      this.clearSnapshotData();
    }, FormStackConstants.FORM_STACK_SNAP_VIEW_DISAPPEAR_DELAY);
  }

  private clearSnapshotData(): void {
    if (!this.mViewData || !this.mCommonData) {
      log.showError('mViewData or mCommonData invalid, do not clear data!');
      return;
    }

    this.mViewData.mIsShow = false;
    FormStackUtil.releasePixelMap(ResourceManager.getInstance().getCachedCardSnapshot(this.mCommonData.mImgCacheKey));
    ResourceManager.getInstance().deleteAppResourceCache(this.mCommonData.mImgCacheKey, 'cardSnapshot');
    this.resetCommonData();
  }

  private resetCommonData(): void {
    if (!this.mCommonData) {
      log.showWarn('mCommonData is undefined, do not reset!');
      return;
    }

    this.mCommonData.mWidth = 0;
    this.mCommonData.mHeight = 0;
    this.mCommonData.mPosX = 0;
    this.mCommonData.mPosY = 0;
    this.mCommonData.mBorderRadius = 0;
    this.mCommonData.mImgCacheKey = '';
    log.showWarn('snap view disappear, reset common data done.');
  }
}