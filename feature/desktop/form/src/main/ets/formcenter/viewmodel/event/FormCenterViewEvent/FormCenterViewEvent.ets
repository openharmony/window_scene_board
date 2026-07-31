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

import {
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
} from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { DeviceHelper, ViewCallback } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  FormCenterViewParam,
  FormDisplayType,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { FormCenterViewModel, CloseReason } from '../../FormCenterViewModel';
import { FormCenterEventInterface } from '../../../interfaces/FormCenterEventInterface';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import { ViewData } from '../../../../default/viewmodel/FormCenterObservedData';
import { SwiperLayoutViewData } from '../../data/SwiperLayoutViewData';
import { BindSheetStateData } from '../../data/BindSheetStateData';
import {
  AppItemInfo,
  CardItemInfo,
  CommonConstants,
  FormCenterLocation,
  FormCenterViewManager,
  FormModel,
} from '@ohos/launchercommon';
import {
  FormCenterResponse,
  FormCenterResponseCode,
  FormManageResponse
} from '../../../../default/service/ServiceInterface';
import { SearchState, SearchStateMgr } from '../../../view/atomicview/SearchComponent';
import FormConstants from '../../../../default/common/constants/FormConstants';
import { FormCenterViewData } from '../../../../default/viewmodel/FormCenterViewData';
import { FormCenterTitleWrapper } from '../../../view/atomicview/formcentertitle/FormCenterTitle';
import { FormCenterTitleStyle } from '../../../viewstyles/FormCenterTitleStyle';
import { FormCenterContentBuilderInterface } from '../../../interfaces/FormCenterContentBuilderInterface';
import { FormCenterContentWrapper } from '../../../view/formcenterview/FormCenterContentView';
import { FormCenterTitleParam, CenterTitleBuilderInterface } from '../../../interfaces/FormCenterTitleBuildeInterface';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';
import { FormCenterStyleConfig } from '../../../viewstyles/manager/FormCenterStyleConfig';

const TAG = 'FormCenterViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormCenterViewEvent implements FormCenterEventInterface {
  protected mViewData: ViewData;
  protected mSwiperLayoutData: SwiperLayoutViewData = new SwiperLayoutViewData();
  protected bindSheetStateData: BindSheetStateData;
  protected mViewStateChangeCallback?: ViewCallback;
  protected mAppInfoList: AppItemInfo[] = [];
  protected mAppInfoListViewData: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  protected mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
  protected mRecommendedCardList: CardItemInfo[] = [];
  protected mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();

  protected mFormCenterViewData: FormCenterViewData = FormCenterViewData.getInstance();
  protected mFormCenterViewModel: FormCenterViewModel = FormCenterViewModel.getInstance();
  protected viewTag = 'FormCenterView';
  private isInStarting: boolean = false;
  private detentsDidChange: boolean = false;
  private closeFormEffect: boolean = false;
  constructor(mAppInfoList: LazyDataSource<AppItemInfo>,
    mRecommendedCardList: CardItemInfo[],
    bindSheetStateData: BindSheetStateData,
    mViewData: ViewData,
    mViewStateChangeCallback?: ViewCallback) {
    this.mAppInfoListViewData = mAppInfoList;
    this.mRecommendedCardList = mRecommendedCardList;
    this.bindSheetStateData = bindSheetStateData;
    this.mViewData = mViewData;
    this.mViewStateChangeCallback = mViewStateChangeCallback;
  }

  public showView(param: FormCenterViewParam): void {
    this.updateFormCenterParam(param);
    this.bindSheetStateData.height = param.viewHeight ? param.viewHeight : this.bindSheetStateData.height;
    if (this.bindSheetStateData.isShow) {
      this.showHideView();
      return;
    }
    log.showInfo('showView height: ' + this.bindSheetStateData.height.toString());
    this.isInStarting = true;
    this.firstShowView(param).catch((e: Error) => log.showError(`firsr show view error: ${e?.message}`));
  }

  public closeView(): void {
    if (this.mFormCenterViewManager.isThemeDetailViewShowing()) {
      this.mFormCenterViewManager.closeThemeDetailView();
    }
    if (!this.bindSheetStateData.isShow) {
      return;
    }
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_MARK_DESKTOP_FREEZE, false);
    this.bindSheetStateData.isShow = false;
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    let response: FormCenterResponse = {code: FormCenterResponseCode.CLOSE_FORM_CENTER};
    GlobalContext.getContext()?.eventHub.emit('waitFormCenterResponse', response);
    if (FormCenterViewModel.getInstance().getCloseReason() !== CloseReason.CLOSE_BY_ADD_FORM) {
      GlobalContext.getContext()?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CLOSE_FORM_MANAGER);
    }
  }

  public hideView(height?: number): void {
    this.bindSheetStateData.height = height ?? 0;
  }

  public getViewState(): boolean {
    return this.bindSheetStateData.isShow;
  }

  public backGestureHandler(): void {
    if (!this.bindSheetStateData.isShow) {
      return;
    }

    log.showWarn('deal backGestureHandler');
    // 获焦状态下，只关闭键盘
    if (this.mSearchStateMgr.getState() === SearchState.FOCUSED) {
      GlobalContext.getContext()?.eventHub.emit(FormConstants.CLOSE_KEYBOARD_OF_FORM_CENTER);
      return;
    }

    // 搜索框有内容，清除搜索框，显示全量列表
    if (this.mSearchStateMgr.getState() === SearchState.EDITED) {
      this.recoverFormCenterView();
      return;
    }

    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    this.bindSheetStateData.isShow = false;
  }

  public onBindSheetAppear(): void {
    this.isInStarting = false;
    TraceUtil.endTrace(DomainName.SCB,
      FormConstants.EDIT_PAGE_TRACE_ENTER_FORM_CENTER, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    log.showWarn('formCenterShow bindSheet onAppear');
  }

  public onBindSheetWillDisAppear(): void {
    this.detentsDidChange = false;
    this.closeFormEffect = false;
    TraceUtil.startTrace(DomainName.SCB, FormConstants.EDIT_PAGE_TRACE_EXIT_FORM_CENTER);
    log.showWarn('bindsheet onWillDisappear');
    AppStorage.setOrCreate('isOpenScreenLockForm', false);
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_MARK_DESKTOP_FREEZE, false);
    // 打断一镜到底动效
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    if (this.bindSheetStateData.isShow) {
      let response: FormCenterResponse = {code: FormCenterResponseCode.CLOSE_FORM_CENTER};
      GlobalContext.getContext()?.eventHub.emit('waitFormCenterResponse', response);
      GlobalContext.getContext()?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CLOSE_FORM_MANAGER);
    }
    this.bindSheetStateData.isShow = false;
     // 确保页面置false之后再打开dock栏，否则dock会拉起失败
    this.mFormCenterViewModel.showSmartDock();
    if (this.mFormCenterViewModel.getCloseReason() !== CloseReason.CLOSE_BY_ADD_FORM) {
      this.mFormCenterViewModel.recoveryAllWindows();
    }
    if (FormCenterViewModel.getInstance().isNegativeScreenOpen) {
      AppStorage.setOrCreate('showFormCenterViewByNegativeScreen', false);
      return;
    }
  }

  public onBindSheetDetentsDidChange(height: number): void {
    log.showInfo('onDetentsDidChange height change: ' + height.toString());
    this.mFormCenterViewData.setCurrentViewHeight(height);
    this.detentsDidChange = true;
  }

  public onBindSheetWillAppear(): void {
    TraceUtil.startTrace(DomainName.SCB,
      FormConstants.EDIT_PAGE_TRACE_ENTER_FORM_CENTER, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    log.showWarn('formCenter will show.');
  }

  public onBindSheetDisAppear(): void {
    TraceUtil.endTrace(DomainName.SCB, FormConstants.EDIT_PAGE_TRACE_EXIT_FORM_CENTER);
    const location: FormCenterLocation = this.mFormCenterViewManager.getFormCenterLocation();
    log.showInfo(`formCenter onBindSheetDisAppear ${location}`);
    if (this.isInStarting && location === FormCenterLocation.SCREEN_LOCK) {
      log.showWarn('formCenter is in starting not trigger onHide when in screen lock');
      return;
    }
    this.mViewStateChangeCallback?.onHide?.(this.viewTag);
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_MARK_DESKTOP_FREEZE, false);
    if (!this.bindSheetStateData.isShow) {
      this.destroyViewData();
    }
  }

  public onBindSheetHeightDidChange(): void {
    if (!this.detentsDidChange && !this.closeFormEffect) {
      log.showInfo('interrupt form effect');
      GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
      this.closeFormEffect = true;
    }
    this.detentsDidChange = false;
  }

  public getTitleBuilder(): CenterTitleBuilderInterface {
    return new FormCenterTitleWrapper();
  }

  public getTitleBuilderParam(): FormCenterTitleParam {
    return {
      text: ResUtils.getInnerStringNumS($r('app.string.add_form_to_desktop')),
      style: FormCenterStyleConfig.getInstance().getStyle()?.titleStyle ?? new FormCenterTitleStyle(),
    };
  }

  public getContentBuilder(): FormCenterContentBuilderInterface {
    return new FormCenterContentWrapper();
  }

  protected showHideView(): void {
    if (this.bindSheetStateData.height !== 0 &&
      this.bindSheetStateData.height !== FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT) {
      log.showInfo('showView reentrant, do nothing');
      return;
    }
    GlobalContext.getContext()?.eventHub.emit('NAVIBarShow', true);
    let bindSheetHeight: number = this.mViewData.bindSheetHeight;
    // 外部设置过高度
    if (this.bindSheetStateData.setHeight) {
      bindSheetHeight = this.bindSheetStateData.setHeight;
    }
    this.bindSheetStateData.height = bindSheetHeight;
    log.showInfo(`recovery formCenterView current height: ${this.bindSheetStateData.height}`);
  }

  protected async firstShowView(param: FormCenterViewParam): Promise<void> {
    this.mViewStateChangeCallback?.onShow?.(this.viewTag);
    this.destroyViewData();
    await this.updateViewData();
    this.mFormCenterViewModel.exitOtherSystemPanel();
    this.mFormCenterViewModel.dealPCShowFormCenter();
    this.updateViewHeight(param.viewHeight, param.viewMaxHeight);
    this.getShowInfo(param.bundleName);
    log.showWarn(`show view, max: ${this.bindSheetStateData.maxHeight}, set: ${this.bindSheetStateData.maxHeight}`);
  }

  protected updateFormCenterParam(param: FormCenterViewParam): void {
    FormCenterViewModel.getInstance().isScreenLock = param.formDisplayType === FormDisplayType.SCREEN_LOCK_CARD;
    FormCenterViewModel.getInstance().updateFormCenterLocation(param);
    FormCenterViewModel.getInstance().setIsSupportCreateAnimate(param.isSupportCreateAnimate);
    FormCenterViewModel.getInstance().setIsSupportDrag(param.isSupportDrag);
    FormCenterViewModel.getInstance().updateIsCardExceedLimit();
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.OTHER);
    FormCenterViewModel.getInstance().isNegativeScreenOpen = param.isNegativeScreenOpen;
    FormCenterViewModel.getInstance().isAsdeOpen = param.isAsdeOpen;
    FormCenterViewModel.getInstance().customGridWidth = param.customGridWidth ?? 0;
  }

  protected destroyViewData(): void {
    log.showInfo('destroyViewData');
    this.bindSheetStateData.resetData();
    this.mAppInfoListViewData.clear();
    this.mRecommendedCardList.length = 0;
    this.mSearchStateMgr.setIsShowSearchResult(false);
    this.mSearchStateMgr.setMatchedValue('');
  }

  protected async updateViewData(): Promise<void> {
    let isPortrait: boolean = AppStorage.get('isPortrait') ?? false;
    ObjectCopyUtil.deepClone(this.mFormCenterViewData.getViewData(isPortrait), this.mViewData);
    this.bindSheetStateData.isSupportSplit = FormModel.getInstance().isSupportFormCenterSplit();
    await this.mFormCenterViewModel.updateFromCenterData();
  }

  protected updateViewHeight(viewHeight?: number, viewMaxHeight?: number): void {
    this.bindSheetStateData.height = this.mViewData.bindSheetHeight;
    if (viewHeight !== undefined) {
      this.bindSheetStateData.maxHeight = viewMaxHeight ?? this.bindSheetStateData.height;
      this.bindSheetStateData.height = Number(viewHeight);
      this.bindSheetStateData.setHeight = this.bindSheetStateData.height;
    }
  }

  protected getShowInfo(bundleName?: string): void {
    let appList: AppItemInfo[] = this.mFormCenterViewModel.getAppList();
    log.showWarn(`recommend form num: ${this.mRecommendedCardList.length}, apps num: ${appList.length}`);
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return;
    }

    for (let index = 0; index < appList.length; index++) {
      this.mAppInfoListViewData.pushItem(appList[index]);
    }
  }

  /**
   * 搜索结束/退出卡片中心恢复界面内容
   */
  protected recoverFormCenterView(): void {
    GlobalContext.getContext()?.eventHub.emit(FormConstants.RESET_SEARCH);
    log.showWarn('recoverFormCenterView');
  }
}