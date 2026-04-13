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

import { ObjectCopyUtil } from '@ohos/componenthelper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, ViewCallback } from '@ohos/frameworkwrapper';
import { AppItemInfo, CardItemInfo, CommonConstants, FormCenterViewManager, } from '@ohos/launchercommon';
import {
  FormCenterViewParam,
  FormDisplayType,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { CloseReason, FormCenterViewModel } from '../../FormCenterViewModel';
import { FormManagerEventInterface } from '../../../interfaces/FormManagerEventInterface';
import { FormCenterResponseCode, FormManageResponse } from '../../../../default/service/ServiceInterface';
import { NavDestinationViewData } from '../../../../default/viewmodel/FormCenterObservedData';
import { FormCenterViewData } from '../../../../default/viewmodel/FormCenterViewData';
import { SwiperLayoutViewData } from '../../data/SwiperLayoutViewData';
import { BindSheetStateData } from '../../data/BindSheetStateData';
import { FormManagerTitleWrapper } from '../../../view/atomicview/FormManagerTitle/FormManagerTitle';
import { SwiperLayoutEventInterface } from '../../../interfaces/SwiperLayoutEventInterface';
import { SwiperLayoutEvent } from '../swiperlayoutevent/SwiperLayoutEvent';
import { ManagerTitleBuilderInterface } from '../../../interfaces/FormManagerSheetTitleInterface';

const TAG = 'FormManagerEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormManagerEvent implements FormManagerEventInterface {
  protected mViewData: NavDestinationViewData;
  protected mSwiperLayoutData: SwiperLayoutViewData;
  protected bindSheetStateData: BindSheetStateData;
  protected mViewStateChangeCallback?: ViewCallback;
  protected mAppInfo: AppItemInfo = new AppItemInfo();
  protected mStartFormInfo: CardItemInfo = new CardItemInfo();
  protected mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
  protected formCenterViewParam: FormCenterViewParam = new FormCenterViewParam();

  constructor(formCenterViewParam: FormCenterViewParam,
    mViewData: NavDestinationViewData,
    bindSheetStateData: BindSheetStateData,
    swiperLayoutData: SwiperLayoutViewData,
    mViewStateChangeCallback?: ViewCallback) {
    this.formCenterViewParam = formCenterViewParam;
    this.mViewData = mViewData;
    this.bindSheetStateData = bindSheetStateData;
    this.mSwiperLayoutData = swiperLayoutData;
    this.mViewStateChangeCallback = mViewStateChangeCallback;
  }

  public showView(param: FormCenterViewParam, callback: () => void): void {
    this.updateFormCenterParam(param);
    if (this.bindSheetStateData.isShow) {
      if (this.bindSheetStateData.height !== 0) {
        log.showInfo('showView reentrant, do nothing');
        return;
      }
      this.bindSheetStateData.height = this.mViewData.bindSheetHeight;
      GlobalContext.getContext()?.eventHub.emit('AIBarShow', true);
      log.showWarn('real open formManagerView height: ' + String(this.bindSheetStateData.height));
      return;
    }
    this.initViewData(this.mViewData);
    this.bindSheetStateData.height = this.formCenterViewParam.viewHeight ?? this.mViewData.bindSheetHeight;
    log.showInfo(`heigt: ${this.bindSheetStateData.height}`);

    let bundleName: string | undefined = this.formCenterViewParam.bundleName;
    log.showWarn(`show ${bundleName} forms`);
    GlobalContext.getContext()?.eventHub.emit('AIBarShow', true);
    this.mStartFormInfo = this.formCenterViewParam.formInfo as CardItemInfo;
    FormCenterViewModel.getInstance().updateFromManagerData(FormCenterViewModel.getInstance().isScreenLock).then(() => {
      this.mAppInfo = FormCenterViewModel.getInstance().getAppInfo(bundleName as string);
      this.mSwiperLayoutData.initViewData(this.mAppInfo, this.mStartFormInfo, param.templateCardList);
      if (CheckEmptyUtils.isEmpty(this.mAppInfo)) {
        log.showError(`can not get ${bundleName} appInfo`);
        return;
      }
      log.showInfo(`start index: ${this.mSwiperLayoutData.swipeTargetIndex}`);
      callback();
    })
  }

  public closeView(): void {
    this.closeFormManager();
  }

  public hideView(): void {
    this.closeFormManager();
  }

  public getViewState(): boolean {
    return this.bindSheetStateData.isShow;
  }

  public backGestureHandler(): void {
    this.closeFormManager();
  }

  public onBindSheetWillDisAppear(): void {
    if (this.bindSheetStateData.isShow) {
      GlobalContext.getContext()?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CLOSE_FORM_MANAGER);
    }
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    this.bindSheetStateData.isShow = false;
    if (this.mFormCenterViewManager.isFormCenterViewShowing()) {
      let param: FormCenterViewParam = this.getFormCenterViewParam();
      if (FormCenterViewModel.getInstance().isNegativeScreenOpen) {
        this.mFormCenterViewManager.openFormCenterViewByNegativeScreen(param);
      } else {
        this.mFormCenterViewManager.openFormCenterView(param);
      }
      GlobalContext.getContext()?.eventHub
        .emit('waitFormCenterResponse', { code: FormCenterResponseCode.BACK_TO_FORM_CENTER });
      log.showWarn('back to formCenterView');
    }
    GlobalContext.getContext()?.eventHub.emit('AIBarShow', false);
    if (FormCenterViewModel.getInstance().isNegativeScreenOpen) {
      AppStorage.setOrCreate('showFormManagerViewByNegativeScreen', false);
    }
  }

  public getTitleBuilder(): ManagerTitleBuilderInterface {
    return new FormManagerTitleWrapper();
  }

  public getSwiperLayoutEvent(): SwiperLayoutEventInterface {
    return new SwiperLayoutEvent(this.mSwiperLayoutData, this.mViewData, this.mAppInfo);
  }

  protected getFormCenterViewParam(): FormCenterViewParam {
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.openHighIndexView = !CheckEmptyUtils.isEmpty(this.mViewStateChangeCallback);
    param.formDisplayType = FormDisplayType.DESKTOP_CARD;
    return param;
  }

  private closeFormManager(): void {
    log.showInfo('closeFormManager');
    if (!this.bindSheetStateData.isShow) {
      return;
    }
    this.bindSheetStateData.isShow = false;
    GlobalContext.getContext().eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    if (FormCenterViewModel.getInstance().getCloseReason() !== CloseReason.CLOSE_BY_ADD_FORM) {
      GlobalContext.getContext()?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CLOSE_FORM_MANAGER);
    }
  }

  private initViewData(data: NavDestinationViewData): void {
    let vd: NavDestinationViewData = FormCenterViewData.getInstance().getViewData(undefined,
      true, FormCenterViewModel.getInstance().isScreenLock).navDestinationViewData;
    data.column = vd.column;
    data.bindSheetWidth = vd.bindSheetWidth;
    data.bindSheetHeight = vd.bindSheetHeight;
    data.viewWidth = vd.viewWidth;
    data.viewHeight = vd.viewHeight;
    data.addFormButtonWidth = vd.addFormButtonWidth;
    data.formViewHeight = vd.formViewHeight;
    data.cardViewMargin = vd.cardViewMargin;
    data.formRate = vd.formRate;
  }

  private updateFormCenterParam(param: FormCenterViewParam): void {
    FormCenterViewModel.getInstance().isScreenLock =
      this.formCenterViewParam.formDisplayType === FormDisplayType.SCREEN_LOCK_CARD;
    FormCenterViewModel.getInstance().updateFormCenterLocation(this.formCenterViewParam);
    FormCenterViewModel.getInstance().setIsSupportCreateAnimate(this.formCenterViewParam.isSupportCreateAnimate);
    FormCenterViewModel.getInstance().setIsSupportDrag(this.formCenterViewParam.isSupportDrag);
    FormCenterViewModel.getInstance().updateIsCardExceedLimit();
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.OTHER);
    FormCenterViewModel.getInstance().isNegativeScreenOpen = param.isNegativeScreenOpen;
    FormCenterViewModel.getInstance().isAsdeOpen = param.isAsdeOpen;
  }
}