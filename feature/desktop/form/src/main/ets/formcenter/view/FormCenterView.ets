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
import { GlobalContext, ViewCallback } from '@ohos/frameworkwrapper';
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
import { FormCenterViewData } from '../../default/viewmodel/FormCenterViewData';
import { FormCenterEventInterface } from '../interfaces/FormCenterEventInterface';
import { BindSheetStateData } from '../viewmodel/data/BindSheetStateData';
import { FormCenterEventFactory } from '../viewmodel/factory/FormCenterEventFactory';
import { FormCenterViewStyle } from '../viewstyles/FormCenterViewStyle';
import { FormCenterTitleParam } from '../interfaces/FormCenterTitleBuildeInterface';
import { FormCenterStyleConfig } from '../viewstyles/manager/FormCenterStyleConfig';
import window from '@ohos.window';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { BusinessError } from '@kit.BasicServicesKit';

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
  @State isOpenDialog: boolean = false;
  @StorageProp('lockReceived') @Watch('closeView') lockReceived: number = 0;
  @StorageLink('folderStatus') @Watch('closeView') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('isPortrait') @Watch('onPortraitChange') mIsPortrait: boolean = true;
  @StorageLink('currColorMode') currColorMode: number = 1;
  @StorageLink('formDragStart') @Watch('closeDialog') formDragStart: boolean = false;
  private dialogController: CustomDialogController | null = null;

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
      if (this.isOpenDialog === false && !DeviceHelper.isPhone()) {
        log.showInfo('open formCenter dialog');
        this.dialogController?.open();
        this.isOpenDialog = true;
      }
    },
    hideView: (height?: number) => {
      this.mEvent?.hideView(height);
    },
    closeView: () => {
      this.mEvent?.closeView();
      if (!DeviceHelper.isPhone() && this.isOpenDialog) {
        log.showInfo('close formCenter dialog');
        this.closeDialog();
      }
    },
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
    this.viewController.closeView();
  }

  private closeDialog() {
    this.isOpenDialog = false;
    this.dialogController?.close();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.mFormCenterViewManager.registerFormCenterViewController('desktop', this.viewController);
    this.dialogController = new CustomDialogController({
      builder: FormCenterDialog({
        controller: this.dialogController!,
        mViewData: this.mViewData,
        mAppInfoList: this.mAppInfoList,
        mStartFormInfo: this.mStartFormInfo,
        mEvent: this.mEvent,
        mViewStateChangeCallback: this.mViewStateChangeCallback,
        bindSheetStateData: this.bindSheetStateData,
        style: this.style,
        preSetIndex: this.preSetIndex,
        closeDialog: () => {
          this.closeDialog();
        }
      }),
      customStyle: true,
      alignment: DialogAlignment.Bottom,
      autoCancel: true,
      showInSubWindow: true,  // 关键：在子窗口中显示
      isModal: false,  // 非模态窗口，减少层级限制
      onDidAppear: () => {
        // 对话框显示后，尝试置顶
        this.bringToFront();
      },
      onWillAppear: () => this.mEvent?.onBindSheetWillAppear(),
      onWillDisappear: () => this.mEvent?.onBindSheetWillDisAppear(),
      onDidDisappear: () => {
        this.mStartFormInfo = new CardItemInfo();
        this.mEvent?.onBindSheetDisAppear();
      },
      onWillDismiss: () => {
        log.showInfo('onWillDismiss to close formCenter dialog');
        this.isOpenDialog = false;
        this.dialogController?.close();
      }
    });
  }

  private async bringToFront(): Promise<void> {
    try {
      // 获取当前应用的主窗口
      let context = GlobalContext.getContext();
      let mainWindow = await window.getLastWindow(context);
      // 设置窗口可获取焦点
      await mainWindow.setWindowFocusable(true);
      log.showInfo('Window focused');
    } catch (error) {
      let err = error as BusinessError;
      log.showError(`Failed to bring window to front: code:${err?.code} message:${err?.message}`);
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    let key: string = 'desktop';
    this.mFormCenterViewManager.unRegisterFormCenterViewController(key);
    GlobalContext.getContext().eventHub.off('formDragStart');
  }

  private onPortraitChange(): void {
    log.showInfo('onPortraitChange: ' + String(this.mIsPortrait));
    if (DeviceHelper.isPad() && this.isOpenDialog) {
      return;
    }
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

  //卡片显示
  build() {
    Stack()
      .position({ x: 0, y: 0 })
      .id(`${TAG}_Stack`)
      .bindSheet(
        this.bindSheetStateData.isShow && DeviceHelper.isPhone(), this.formBindSheetBuilder(), {
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

@CustomDialog
export struct FormCenterDialog {
  controller: CustomDialogController;
  private mRecommendedCardList: CardItemInfo[] = [];
  private mViewStateChangeCallback: ViewCallback | null = null;
  private mEvent: FormCenterEventInterface | null = null;
  private style: FormCenterViewStyle = FormCenterStyleConfig.getInstance().getStyle();
  @State bindSheetStateData: BindSheetStateData = new BindSheetStateData();
  @State mViewData: ViewData = new ViewData();
  @State mAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  @State mStartFormInfo: CardItemInfo = new CardItemInfo();
  @State preSetIndex: number = 0;
  @StorageLink('isPortrait') mIsPortrait: boolean = true;
  @StorageLink('screenWidth') @Watch('onPadScreenLayoutChange') screenWidth: number = 0;
  @State padContentKey: number = 0;
  private padLayoutRefreshTimer: number = -1;
  closeDialog?: () => void;

  private onPadScreenLayoutChange(): void {
    this.schedulePadLayoutRefresh();
  }

  private schedulePadLayoutRefresh(): void {
    if (!DeviceHelper.isPad()) {
      return;
    }
    if (this.padLayoutRefreshTimer !== -1) {
      clearTimeout(this.padLayoutRefreshTimer);
    }
    this.padLayoutRefreshTimer = setTimeout(() => {
      this.padLayoutRefreshTimer = -1;
      this.updatePadDialogLayout();
    }, 50);
  }

  private updatePadDialogLayout(): void {
    log.showInfo(`FormCenterDialog updatePadDialogLayout isPortrait: ${this.mIsPortrait}, ` +
      `screenWidth: ${this.screenWidth}`);
    ObjectCopyUtil.deepClone(FormCenterViewData.getInstance().getViewData(this.mIsPortrait), this.mViewData);
    this.bindSheetStateData.height = this.mViewData.bindSheetHeight;
    this.padContentKey++;
  }

  private getTitleBuilderParam(): FormCenterTitleParam {
    let param: FormCenterTitleParam = this.mEvent?.getTitleBuilderParam() ?? {};
    if (!DeviceHelper.isPhone()) {
      param.onCloseClick = (): void => {
        FormCenterViewManager.getInstance().closeFormCenterView();
      };
    }
    return param;
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
    .borderRadius(20)
    .backgroundColor($r('app.color.formCenter_background'))
    .backgroundEffect(this.style.bgrEffect, { disableSystemAdaptation: true })
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      this.formBindSheetBuilder()
    }
    .width(DeviceHelper.isPad() ? this.mViewData.bindSheetWidth : '70%')
    .height(DeviceHelper.isPad() ? this.mViewData.bindSheetHeight : '75%')
    .key(DeviceHelper.isPad() ? `form_center_dialog_${this.padContentKey}` : 'form_center_dialog')
    .margin({ bottom: 30 })
    .onClick(() => {
      if (this.closeDialog) {
        this.closeDialog?.();
      }
    })
  }
}
