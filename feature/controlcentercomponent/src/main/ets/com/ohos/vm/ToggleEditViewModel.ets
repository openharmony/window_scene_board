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

import curves from '@ohos.curves';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { EvtBus, obtainLocalEvent, sEventManager, GlobalContext } from '@ohos/frameworkwrapper';
import { HoverConstants } from '@ohos/commonconstants';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ToggleEditViewData, ToggleEditType } from './ToggleEditViewData';
import { SysApiWrapper } from '../common/SysApiWrapper';
import { FIXED_TOP_TOGGLES } from '../common/Constants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import lazy sControlCenterController from '../controller/ControlCenterController';
import { QuickToggleController } from '../controller/QuickToggleController';
import { DropdownBackPressEvent } from '../common/Events';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { IotEditViewModel } from './IotEditViewModel';
import { QuickToggleEditViewModel } from './QuickToggleEditViewModel';
import { TopToggleEditViewModel } from './TopToggleEditViewModel';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { TOGGLE_EDIT_LIBRARY_HEIGHT } from '../common/Constants';

const TAG = 'ToggleEditViewModel';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);
const DELAY_SAVE_TOGGLES: number = 100;
const LIBRARY_COLLAPSE_THRESHOLD: number = 120;

export enum ToggleButtonType {
  LEFT_BUTTON = 1,
  RIGHT_BUTTON = 2,
  ADD_BUTTON = 3,
  COLLAPSE_BUTTON = 4
}

export class CollapseLibraryType {
  public static readonly CLICK_BLANK = 1; // 点击备选库以外的空白区域
  public static readonly CLICK_SLIDE_BAR = 2; // 点击小横条
  public static readonly SLIDE_DOWN_BAR = 3; // 下滑小横条
  public static readonly BACK_GESTURE = 4; // 系统左右返回手势
  public static readonly CLICK_COLLAPSE_LIB = 5; // 点击收起备选库按钮
  public static readonly OTHER = 6; // 其它
}

export class ToggleEditViewModel {
  public scroller: Scroller = new Scroller();
  public previewToggles: string[] = [];
  public libraryToggles: string[] = [];
  public previewTopToggles: string[] = [];
  public libraryTopToggles: string[] = [];
  public showToast?: (msg: ResourceStr) => void;
  public saveConfirmController?: CustomDialogController
  public scrollBlurController?: ScrollBlurController;
  private viewData: ToggleEditViewData;
  private isSaveConfirmDialogShowing: boolean = false;
  private eventManager = EvtBus.createEventManager();
  private collapseLibraryType: number = CollapseLibraryType.OTHER;
  private editHeadAreaHeight: number = 116;
  public iotViewModel?: IotEditViewModel;
  public quickToggleViewModel?: QuickToggleEditViewModel;
  public topToggleViewModel?: TopToggleEditViewModel;

  constructor(viewData: ToggleEditViewData, showDoubleColumn: boolean) {
    this.viewData = viewData;
  }

  /**
   * 初始化头部开关编辑viewModel
   *
   * @param quickToggleViewModel
   */
  public initTopToggleViewModel(topToggleViewModel: TopToggleEditViewModel): void {
    this.topToggleViewModel = topToggleViewModel;
    this.topToggleViewModel.previewToggles = this.previewTopToggles;
    this.topToggleViewModel.libraryToggles = this.libraryTopToggles;
    this.topToggleViewModel.scroller = this.scroller;
    this.topToggleViewModel.scrollBlurController = this.scrollBlurController;
    this.topToggleViewModel.showToast = this.showToast;
  }

  /**
   * 初始化快捷开关编辑viewModel
   *
   * @param quickToggleViewModel
   */
  public initQuickToggleViewModel(quickToggleViewModel: QuickToggleEditViewModel): void {
    this.quickToggleViewModel = quickToggleViewModel;
    this.quickToggleViewModel.previewToggles = this.previewToggles;
    this.quickToggleViewModel.libraryToggles = this.libraryToggles;
    this.quickToggleViewModel.scroller = this.scroller;
    this.quickToggleViewModel.scrollBlurController = this.scrollBlurController;
    this.quickToggleViewModel.showToast = this.showToast;
  }

  /**
   * 初始化iot编辑viewModel
   *
   * @param iotViewModel
   */
  public initIotViewModel(iotViewModel: IotEditViewModel): void {
    this.iotViewModel = iotViewModel;
    this.iotViewModel.scroller = this.scroller;
    this.iotViewModel.initViewModelFunc(
      // 第一次返回主页，第二次弹窗
      () => {
        this.onBackButtonClicked();
        this.onBackButtonClicked();
      },
      (y: number) => {
        this.scrollBlurController?.scrollToWithBlur(y);
      },
      (msg: ResourceStr) => {
        this.showToast?.(msg);
      }
    )
  }

  public onViewAppear = (): void => {
    this.eventManager.on(DropdownBackPressEvent, () => {
      this.setCollapseLibraryReason(CollapseLibraryType.BACK_GESTURE);
      this.onBackButtonClicked();
    });
    this.quickToggleViewModel?.onViewAppear();
    this.topToggleViewModel?.onViewAppear();
  }
  public onViewDisappear = (): void => {
    this.eventManager.offAll();
    this.setSaveConfirmDialogState(false);
  }
  public handleOnHover: Function = (type: ToggleButtonType, isHover?: boolean) => {
    if (isHover === undefined) {
      return;
    }
    SysApiWrapper.animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.viewData.isHover = isHover;
      switch (type) {
        case ToggleButtonType.LEFT_BUTTON:
          this.viewData.leftBtnScale =
            isHover ? HoverConstants.HOVER_SETTING_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
          break;
        case ToggleButtonType.RIGHT_BUTTON:
          this.viewData.rightBtnScale =
            isHover ? HoverConstants.HOVER_SETTING_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
          break;
        case ToggleButtonType.ADD_BUTTON:
          this.viewData.addBtnScale =
            isHover ? HoverConstants.HOVER_BRIGHTNESS_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
          break;
        case ToggleButtonType.COLLAPSE_BUTTON:
          this.viewData.collapseBtnScale =
            isHover ? HoverConstants.HOVER_BRIGHTNESS_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
          break;
        default:
          break;
      }
    });
  }

  public onEditModeChange = (isEditMode: boolean): void => {
    log.showInfo(`EditModeChange : isEdiwMode:${isEditMode}`);
    if (!isEditMode) {
      return;
    }
    TraceUtil.startTrace(DomainName.CC, 'onEnterEdit');
    ControlCenterHiSysEventUtil.reportCCEditIconClick({
      TIMESTAMP:  `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.previewToggles.length,
      SWITCHLIST: this.previewToggles.join(','),
      LOCKSTATUS: AppStorage.get('lockStatus'),
    })
    log.showInfo('on enter edit mode');
    this.switchHeader(true);
    // 边框动画
    this.showPreviewToggles();
  }
  public onBackButtonClicked = (): void => {
    if (this.isSaveConfirmDialogShowing) {
      log.showWarn('onBackButtonClicked, but confirm dialog is showing');
      this.setSaveConfirmDialogState(false);
      return;
    }
    if (this.viewData.showIotLibrary) {
      log.showInfo('onBackButtonClicked, iot is editing');
      this.iotViewModel?.collapseIotEdit();
      return;
    }
    if (this.viewData.showQuickToggleLibrary || this.viewData.showTopToggleLibrary) {
      log.showInfo('onBackButtonClicked, showing toggle library');
      this.hideToggleLibrary();
      this.collapseLibraryType = CollapseLibraryType.OTHER;
      return;
    }
    log.showInfo('onBackButtonClicked');
    let originQuickToggleData: string[] = Array.from(QuickToggleController.getInstance().getToggleData().quickToggle);
    let originTopToggleData: string[] = Array.from(QuickToggleController.getInstance().getToggleData().topToggle);
    if (!this.iotViewModel?.isIotEdited && this.checkEquals(originQuickToggleData, this.previewToggles) &&
    this.checkEquals(originTopToggleData, this.getTopToggleDataWithFixed())) {
      log.showInfo('iot and toggles not changed');
      this.quitEditMode(false);
      return;
    }
    this.setSaveConfirmDialogState(true);
  };

  public setCollapseLibraryReason(reason: number): void {
    this.collapseLibraryType = reason;
  }

  public onSaveButtonClicked = (): void => {
    log.showInfo('onSaveButtonClicked');
    ControlCenterHiSysEventUtil.reportCCEditClickSuccess({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.previewToggles.length,
      SWITCHLIST: this.previewToggles.join(','),
    })
    this.saveToggles();
    this.quitEditMode(true);
  };

  // 弹窗选择保存
  public onSaveOptionClicked = (): void => {
    log.showInfo('onSaveOptionClicked');
    ControlCenterHiSysEventUtil.reportCCEditDialogClickSave({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.previewToggles.length,
      SWITCHLIST: this.previewToggles.join(','),
    })
    this.isSaveConfirmDialogShowing = false;
    this.saveToggles();
    this.quitEditMode(true);
  }

  // 弹窗选择不保存
  public onCancelOptionClicked = (): void => {
    log.showInfo('onCancelOptionClicked');
    ControlCenterHiSysEventUtil.reportCCEditDialogClickCancel({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
    })
    this.isSaveConfirmDialogShowing = false;
    this.quitEditMode(false);
  }

  // 点击空白处弹窗消失
  public onConfirmDialogCanceled = (): void => {
    log.showInfo('onConfirmDialogCanceled');
    this.isSaveConfirmDialogShowing = false;
  }

  private hideToggleLibrary = (): void => {
    TraceUtil.startTrace(DomainName.CC, 'hideToggleLibrary');
    ControlCenterHiSysEventUtil.reportCCEditCollapseLibrary({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      TYPE: this.collapseLibraryType,
    })
    SysApiWrapper.animateTo({
      duration: 450,
      curve: curves.springCurve(0, 1, 228, 28),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'hideToggleLibrary');
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_header_btn_left_FOCUS');
      }
    }, () => {
      this.viewData.showTopToggleLibrary = false;
      this.viewData.showQuickToggleLibrary = false;
      this.viewData.quickLibraryTrans = TOGGLE_EDIT_LIBRARY_HEIGHT;
      this.viewData.topLibraryTrans = TOGGLE_EDIT_LIBRARY_HEIGHT;
      this.topToggleViewModel?.updatePreviewHeight();
      this.quickToggleViewModel?.updatePreviewHeight();
      if (this.scroller.currentOffset()?.yOffset > 0) {
        if (this.scroller.currentOffset()?.yOffset < this.viewData.editTopPreviewPanelHeight) {
          this.scrollBlurController?.scrollToWithBlur(0);
        } else {
          this.scrollBlurController?.scrollToWithBlur(this.viewData.editTopPreviewPanelHeight);
        }
      } else {
        this.scrollBlurController?.inactiveScrollerBlur();
      }
    })
  };

  public onScrollStart = (): void => {
    log.showInfo(`onScrollStart`);
    this.iotViewModel?.iotProxy?.send({ 'method': 'canClick', 'param': 0, });
  }

  public onScrollStop = (): void => {
    log.showInfo(`onScrollStop`);
    this.iotViewModel?.iotProxy?.send({ 'method': 'canClick', 'param': 1, });
  }

  public onScrollSizeChange = (oldValue: SizeOptions, newValue: SizeOptions): void => {
    this.viewData.scrollHeight = (newValue.height as number - this.editHeadAreaHeight) ?? 0;
  }

  public onPanActionStart(event: GestureEvent): void {
    log.showInfo(`onPanActionStart offsetY: ${event.offsetY}`);
  }

  /**
   * 备选库跟手拖动位移
   * @param event 拖拽事件
   * @param toggleEditType 备选库类型
   */
  public onPanActionUpdate(event: GestureEvent, toggleEditType: ToggleEditType): void {
    log.showInfo(`onPanActionUpdate offsetY: ${event.offsetY}`);
    let transLate: number = event.offsetY;
    if (transLate < 0) {
      transLate = 0;
    }
    if (transLate > TOGGLE_EDIT_LIBRARY_HEIGHT) {
      transLate = TOGGLE_EDIT_LIBRARY_HEIGHT
    }
    switch (toggleEditType) {
      case ToggleEditType.TOP_TOGGLE:
        this.viewData.topLibraryTrans = transLate;
        break;
      case ToggleEditType.QUICK_TOGGLE:
        this.viewData.quickLibraryTrans = transLate;
        break;
      case ToggleEditType.IOT:
        this.viewData.iotLibraryTrans = transLate;
        break;
      default:
        break;
    }
  }

  public onPanActionEnd(event: GestureEvent, toggleEditType: ToggleEditType): void {
    log.showInfo(`onPanActionEnd offsetY: ${event.offsetY}`)
    // 达到收起阈值就收起，否则回弹
    if (event.offsetY > LIBRARY_COLLAPSE_THRESHOLD) {
      this.setCollapseLibraryReason(CollapseLibraryType.SLIDE_DOWN_BAR);
      this.onBackButtonClicked();
      return;
    }
    SysApiWrapper.animateTo({
      duration: 450,
      curve: curves.springCurve(0, 1, 228, 28),
    }, () => {
      switch (toggleEditType) {
        case ToggleEditType.TOP_TOGGLE:
          this.viewData.topLibraryTrans = 0;
          break;
        case ToggleEditType.QUICK_TOGGLE:
          this.viewData.quickLibraryTrans = 0;
          break;
        case ToggleEditType.IOT:
          this.viewData.iotLibraryTrans = 0;
          break;
        default:
          break;
      }
    })
  }

  private showPreviewToggles(): void {
    TraceUtil.startTrace(DomainName.CC, 'showPreviewToggles');
    SysApiWrapper.animateTo({
      duration: 250,
      curve: Curve.Friction,
      onFinish: () => {
        SysApiWrapper.animateTo({
          duration: 400,
          curve: Curve.Friction,
          onFinish: () => {
            this.viewData.enterEditFinished = true;
            this.viewData.loadToggleLibrary = true;
            TraceUtil.endTrace(DomainName.CC, 'showPreviewToggles');
            TraceUtil.endTrace(DomainName.CC, 'onEnterEdit');
          },
        }, () => {
          this.viewData.borderScale = 1;
          this.viewData.previewToggleScale = 1;
        });
      }
    }, () => {
      this.viewData.previewToggleScale = 1.03;
      this.viewData.toggleSubscriptScale = 1;
      this.viewData.toggleSubscriptOpacity = 1;
    });
    SysApiWrapper.animateTo({
      duration: 250,
      curve: Curve.Sharp,
      onFinish: () => {
        SysApiWrapper.animateTo({
          duration: 400,
          curve: Curve.Sharp,
        }, () => {
          this.viewData.borderScale = 1;
        });
      }
    }, () => {
      this.viewData.borderScale = 1.01;
    });
    SysApiWrapper.animateTo({
      duration: 750,
      curve: Curve.Linear,
    }, () => {
      this.viewData.borderColor = '#99ffffff';
    });
  }

  private checkEquals(source: string[], target: string[]): boolean {
    if (source.length !== target.length) {
      return false;
    }
    for (let i = 0; i < source.length; ++i) {
      if (source[i] !== target[i]) {
        return false;
      }
    }
    return true;
  }

  private saveToggles(): void {
    SysApiWrapper.setTimeout(() => {
      TraceUtil.startTrace(DomainName.CC, 'saveToggles');
      QuickToggleController.getInstance().saveQuickToggleData(this.previewToggles);
      QuickToggleController.getInstance().saveTopToggleData(this.getTopToggleDataWithFixed());
      TraceUtil.endTrace(DomainName.CC, 'saveToggles');
    }, DELAY_SAVE_TOGGLES);
  }

  /**
   * 获取含有固定开关的头部开关列表
   * @returns
   */
  private getTopToggleDataWithFixed(): string[] {
    return FIXED_TOP_TOGGLES.concat(this.previewTopToggles);
  }

  private setSaveConfirmDialogState(isShow: boolean) {
    if (!this.saveConfirmController) {
      log.showWarn('saveConfirmController is null or undefined');
      this.isSaveConfirmDialogShowing = false;
      return;
    }
    if (isShow === this.isSaveConfirmDialogShowing) {
      log.showWarn(`confirm dialog state not changed: ${isShow}`);
      return;
    }
    if (isShow) {
      this.isSaveConfirmDialogShowing = true;
      this.saveConfirmController?.open();
    } else {
      this.saveConfirmController?.close();
      this.isSaveConfirmDialogShowing = false;
    }
  }

  private quitEditMode(saveIot: boolean): void {
    TraceUtil.startTrace(DomainName.CC, 'backHome');
    TraceUtil.startTrace(DomainName.CC, 'quitEditMode');
    log.showInfo(`back home, save iot:${saveIot}`);
    if (saveIot && this.iotViewModel?.needDelayReleaseIot) {
      sControlCenterController.setDelayReleaseIot(true);
    }
    this.iotViewModel?.iotProxy?.send({ 'method': saveIot ? 'saveBackToHome' : 'cancelBackToHome' });
    SysApiWrapper.animateTo({
      duration: 280,
    }, () => {
      this.viewData.borderColor = '#00ffffff';
      this.viewData.toggleSubscriptScale = 0.8;
      this.viewData.toggleSubscriptOpacity = 0;
    })
    // 提前显示主页，抵消主页显示前的准备时间
    SysApiWrapper.setTimeout(() => {
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
      TraceUtil.endTrace(DomainName.CC, 'quitEditMode');
    }, 250);
  }

  private switchHeader(isEdit: boolean): void {
    log.showInfo(`switchHeader start:${isEdit}`);
    this.viewData.showEditHeader = isEdit;
    if (isEdit) {
      this.iotViewModel?.notifyIot();
    }
  }

  // 对于目前获焦的组件，主动消费掉对应的按键
  onKeyPreForbidAction(event: KeyEvent, direction: number): boolean {
    return direction === event.keyCode;
  }
}