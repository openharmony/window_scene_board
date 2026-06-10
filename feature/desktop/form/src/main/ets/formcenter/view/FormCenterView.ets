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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewCallback } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  AppItemInfo,
  CardItemInfo,
  FormCenterViewManager,
  DeviceState,
  FormModel,
} from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import {
  FormCenterViewController,
  FormCenterViewParam,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FrameCount } from '@ohos/systemuicommon/src/main/ets/utils/FrameCount';
import { ViewData } from '../../default/viewmodel/FormCenterObservedData';
import { FormCenterEventInterface } from '../interfaces/FormCenterEventInterface';
import { BindSheetStateData } from '../viewmodel/data/BindSheetStateData';
import { FormCenterEventFactory } from '../viewmodel/factory/FormCenterEventFactory';
import { FormCenterViewStyle } from '../viewstyles/FormCenterViewStyle';
import { FormCenterTitleParam } from '../interfaces/FormCenterTitleBuildeInterface';
import { FormCenterStyleConfig } from '../viewstyles/manager/FormCenterStyleConfig';

const TAG = 'FormCenterView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * Form Center View.
 */
@Component
export struct FormCenterView {
  private mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
  private mRecommendedCardList: CardItemInfo[] = [];
  private mViewStateChangeCallback?: ViewCallback;
  private mEvent?: FormCenterEventInterface;
  private style: FormCenterViewStyle = FormCenterStyleConfig.getInstance().getStyle();
  @State bindSheetStateData: BindSheetStateData = new BindSheetStateData();
  @State mViewData: ViewData = new ViewData();
  @State mAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  @Provide mStartFormInfo: CardItemInfo = new CardItemInfo();
  @Provide preSetIndex: number = 0;
  @State frameCount: FrameCount = new FrameCount();
  @StorageProp('lockReceived') @Watch('closeView') lockReceived: number = 0;
  @StorageLink('folderStatus') @Watch('closeView') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('isPortrait') @Watch('onPortraitChange') mIsPortrait: boolean = true;
  @StorageLink('currColorMode') currColorMode: number = 1;

  private viewController: FormCenterViewController = {
    showView: (param: FormCenterViewParam): void => {
      log.showInfo(`showView, isNegativeScreenOpen: ${param.isNegativeScreenOpen}, size: ${this.mAppInfoList.totalCount()}`);
      this.mEvent = FormCenterEventFactory.createFormCenterEvent({
        formCenterViewParam: param,
        mAppInfoList: this.mAppInfoList,
        mRecommendedCardList: this.mRecommendedCardList,
        mViewStateChangeCallback: this.mViewStateChangeCallback,
        mViewData: this.mViewData,
        bindSheetStateData: this.bindSheetStateData,
      });
      this.mEvent.showView(param);
      this.initStartCardItemInfo(param);
      this.style = FormCenterStyleConfig.getInstance().getStyle();
      if (this.mFormCenterViewManager.getFormCenterBlurDisable()) {
        this.style.blurStyle = BlurStyle.NONE;
        this.style.backgroundColor = $r('sys.color.ohos_id_color_panel_bg');
      }
      this.bindSheetStateData.isShow = true;
    },
    hideView: (height?: number) => {
      this.mEvent?.hideView(height);
    },
    closeView: () => this.mEvent?.closeView(),
    getViewState: () => this.mEvent?.getViewState() ?? false,
    backGestureHandler: () => this.mEvent?.backGestureHandler(),
    recoveryDefaultHeight: () => this.recoveryDefaultHeight(),
  }

  private initStartCardItemInfo(param: FormCenterViewParam): void {
    if (param.formInfo) {
      // 深拷贝，防止param.formInfo中的themeId发生变化
      this.mStartFormInfo = ObjectCopyUtil.deepClone<CardItemInfo>(param.formInfo);
      return;
    }

    if (param.bundleName) {
      this.mStartFormInfo = FormModel.getInstance().getAppItemFormInfo(param.bundleName)?.[0] ?? new CardItemInfo();
    }
  }

  private recoveryDefaultHeight(): void {
    this.bindSheetStateData.changeDetents = !this.bindSheetStateData.changeDetents;
    this.preSetIndex = 0;
  }

  private closeView() {
    this.mEvent?.closeView();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.mFormCenterViewManager.registerFormCenterViewController('desktop', this.viewController);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    let key: string = 'desktop';
    this.mFormCenterViewManager.unRegisterFormCenterViewController(key);
  }

  private onPortraitChange(): void {
    log.showInfo('onPortraitChange: ' + String(this.mIsPortrait));
    this.closeView();
  }

  private getTitleBuilderParam(): FormCenterTitleParam {
    let param: FormCenterTitleParam = this.mEvent?.getTitleBuilderParam() ?? {};
    return param;
  }

  private formCenterSheetDismiss(sheetDismiss: SheetDismiss): void {
    let isScreenLockFormDrag: boolean | undefined = AppStorage.get<boolean>('isScreenLockFormDrag');
    if (isScreenLockFormDrag) {
      log.showInfo('screenLock card is drag');
      return;
    }
    sheetDismiss.dismiss();
  }


  @Builder
  formBindSheetBuilder() {
    Column() {
      this.mEvent?.getTitleBuilder().buildTitle?.()?.builder(this.getTitleBuilderParam())
      this.mEvent?.getContentBuilder().buildView().builder({
        mViewData: this.mViewData,
        mAppInfoList: this.mAppInfoList,
        mRecommendedCardList: this.mRecommendedCardList,
        bindSheetStateData: this.bindSheetStateData,
        openHighIndexView: !CheckEmptyUtils.isEmpty(this.mViewStateChangeCallback),
        style: this.style,
      })
    }
    .id(`${TAG}_Top_Column`)
    .backgroundColor(this.style.topBgrColor)
    /*.backgroundBrightnessInternal(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      this.style.brightnessDark : this.style.brightness)*/
    .backgroundEffect(this.style.bgrEffect, { disableSystemAdaptation: true })
  }

  build() {
    Stack()
      .position({ x: 0, y: 0 })
      .id(`${TAG}_Stack`)
      .bindSheet(
        this.bindSheetStateData.isShow, this.formBindSheetBuilder(), {
        width: this.style.bindSheetWidth ?? this.mViewData.bindSheetWidth,
        height: this.style.bindSheetHeight ?? this.mViewData.bindSheetHeight,
        showClose: this.style.showClose,
        dragBar: this.style.dragBar,
        title: this.style.getTitle() ? { title: this.style.getTitle() } : undefined,
        preferType: this.style.preferType,
        blurStyle: this.style.blurStyle,
        backgroundColor: this.style.backgroundColor,
        detents: !this.style.changeDetents ? undefined : this.bindSheetStateData.changeDetents ?
          [this.bindSheetStateData.height, this.bindSheetStateData.maxHeight] :
          [this.bindSheetStateData.height, this.bindSheetStateData.maxHeight, 0],
        mode: SheetMode.EMBEDDED,
        shadow: this.style.shadow,
        scrollSizeMode: ScrollSizeMode.CONTINUOUS,
        maskColor: this.style.maskColor,
        offset: this.bindSheetStateData.sheetOffset,
        onDetentsDidChange: (height: number) => this.mEvent?.onBindSheetDetentsDidChange(height),
        onWillAppear: () => this.mEvent?.onBindSheetWillAppear(),
        onAppear: () => this.mEvent?.onBindSheetAppear(),
        onWillDisappear: () => this.mEvent?.onBindSheetWillDisAppear(),
        onDisappear: () => {
          this.mStartFormInfo = new CardItemInfo();
          this.mEvent?.onBindSheetDisAppear()
        },
        onHeightDidChange: () => this.mEvent?.onBindSheetHeightDidChange?.(),
        radius: this.style.radius,
        shouldDismiss: (sheetDismiss: SheetDismiss) => {
          this.formCenterSheetDismiss(sheetDismiss);
        },
        onWillSpringBackWhenDismiss: () => {}
      })
  }
}
