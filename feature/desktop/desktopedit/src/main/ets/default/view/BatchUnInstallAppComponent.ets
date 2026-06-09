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

import { CustomContentDialog, LengthMetrics } from '@kit.ArkUI';
import {
  CommonConstants,
  editModeManager,
  EditModeUtils,
  LayoutViewModel,
  PageDesktopModel,
  StyleConstants,
} from '@ohos/launchercommon';
import Curves from '@ohos.curves';
import display from '@ohos.display';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import type abilityCommon from '@ohos.app.ability.common';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { RTLUtil, StateEx } from '@ohos/componenthelper';
import {
  batchUninstallChain,
  UninstallMode,
  launcherVisualEffectMgr,
  RemoveDialogConfig
} from '@ohos/launchercommon/Index'
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';

const TAG = 'UnInstallAppComponent';

/**
 * dialog up arrow width
 */
const UP_ARROW_WIDTH = 9;

/**
 * dialog up arrow height
 */
const UP_ARROW_HEIGHT = 3;

/**
 * dialog radius
 */
const RADIUS = 35;

/**
 * dialog width in foldable expand state
 */
const WIDTH_IN_FOLD_EXPAND_STATE = 328;

/**
 * dialog background color
 */

const DIALOG_BUTTON_BG_COLOR = 'rgba(0, 0, 0, 0)';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const ICON_SCALE = 1.5;

const DIVIDER_WIDTH = 2;

/**
 * UX规格 分身角标大小及位置偏移信息
 */
const APP_CLONE_BADGE_SIZE = 21;
const APP_CLONE_BADGE_OFFSETX = 6;
const APP_CLONE_BADGE_OFFSETY = 2;

@CustomDialog
export struct BatchUnInstallAppComponent {
  @Link isShowRemoveDialog: boolean;
  @State popScale: number = 0;
  @State iconOneScale: number = 1;
  @State dialogOpacity: number = 1;
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State isUsedForAnimation: boolean = false;
  @State popHeight: number = 0;
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @Link dialogConfig: RemoveDialogConfig;
  isUninstallApp: boolean = false;
  controller?: CustomDialogController;
  cancel?: Function;
  confirm?: Function;
  jump2Uninstall?: Function;
  upArrowCenterX: number = 0;
  offsetY: number = 0;
  dropX: number = 0;
  dropY: number = 0;
  private upArrowWidth: number = vp2px(UP_ARROW_WIDTH);
  private upArrowHeight: number = vp2px(UP_ARROW_HEIGHT);
  private upArrowX: number = 0;
  private radius: number = vp2px(RADIUS);
  private popWidth: number = 0;
  private iconX: number = 0;
  private iconY: number = 0;
  private centerX: number = 0;
  private displayWidth: number = 0;
  private isFoldablePhoneExpandStatus: boolean = false;
  private desktopContext?: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
  @State isNeedTipsAppTitle: string = '';
  @State isNeedTipsAppContent: string = '';
  @State dialogOpacityEx: StateEx<number> = launcherVisualEffectMgr.getDesktopDialogOpacity();
  @Prop singleContext?: SingleContext;
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();

  async aboutToAppear(): Promise<void> {
    this.isFoldablePhoneExpandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    if (this.isWideMode()) {
      this.popWidth = vp2px(WIDTH_IN_FOLD_EXPAND_STATE);
      try {
        this.displayWidth = display.getDefaultDisplaySync().width;
      } catch (e) {
        log.showError('getDefaultDisplaySync failed');
      }
      this.upArrowX =
        vp2px(WIDTH_IN_FOLD_EXPAND_STATE + StyleConstants.DEFAULT_20) -
        this.displayWidth + this.upArrowCenterX - this.upArrowWidth / 2;
      this.iconX = px2vp(this.displayWidth * 0.75) - StyleConstants.DEFAULT_ADD_APP_SIZE / 2;
      if (RTLUtil.isRTL()) {
        this.upArrowX = this.upArrowCenterX - this.upArrowWidth / 2 - vp2px(StyleConstants.DEFAULT_20);
      }
    } else {
      this.popWidth = vp2px(LayoutViewModel.getInstance(this.singleContext).getScreenWidth() -
        EditModeStyleConstants.EDIT_MODE_BUTTON_MARGIN_LEFT_RIGHT
      );
      this.upArrowX =
        this.upArrowCenterX - this.upArrowWidth / 2 -
        vp2px(EditModeStyleConstants.EDIT_MODE_BUTTON_MARGIN_LEFT_RIGHT / 2);
      this.iconX = LayoutViewModel.getInstance(this.singleContext).getScreenWidth() / 2 -
        StyleConstants.DEFAULT_ADD_APP_SIZE / 2;
    }
    log.showInfo(`Remove dialog aboutToAppear ${this.isFoldablePhoneExpandStatus} , ${this.popWidth}`);
    this.iconY = this.offsetY + StyleConstants.DEFAULT_30 + UP_ARROW_HEIGHT;
    if (this.isUninstallApp) {
      this.translateX = this.dropX - this.iconX;
      this.translateY = this.dropY - this.iconY;
    }
    this.centerX = this.upArrowX + this.upArrowWidth / 2;
    this.desktopContext?.eventHub.on('EditMode_Close_Dialog', (): void => {
      this.cancel?.();
      this.dealCancelDialogAnimation();
    });
  }

  aboutToDisappear(): void {
    this.desktopContext?.eventHub.off('EditMode_Close_Dialog');
  }

  private dealCancelDialogAnimation(): void {
    animateTo({
      curve: Curves.springMotion(0.331, 0.84),
      duration: 200,
      onFinish: () => {
        this.controller?.close();
      }
    }, () => {
      this.popScale = 0.8;
      this.dialogOpacity = 0;
    });
  }

  private dealConfirmRemoveAnimation(): void {
    this.dealCancelDialogAnimation();
  }

  private isWideMode(): boolean {
    return this.isFoldablePhoneExpandStatus || DeviceHelper.isPad();
  }

  private dealOpenAnimation(): void {
    if (this.popScale === 1) {
      return;
    }
    animateTo({
      curve: Curves.springMotion(0.331, 0.84, 0),
      onFinish: () => {
        this.isShowRemoveDialog = true;
      }
    }, () => {
      this.popScale = 1;
      this.translateX = 0;
      this.translateY = 0;
    });
  }

  /**
   * build background pop
   *
   * @returns pop path
   */
  buildPopup(): string {
    let commands: string = `M0 ${this.upArrowHeight}`;
    commands += `H${this.upArrowX}`;
    commands += `C${this.upArrowX + this.upArrowWidth / 4} ${this.upArrowHeight * 3 / 4} ${this.upArrowX +
      this.upArrowWidth * 3 / 8} 0 ${this.upArrowX + this.upArrowWidth / 2} 0`;
    commands += `S${this.upArrowX + this.upArrowWidth * 3 / 4} ${this.upArrowHeight * 3 / 4} ${this.upArrowX +
    this.upArrowWidth} ${this.upArrowHeight}`;
    commands += `H${this.popWidth -
    this.radius} Q${this.popWidth} ${this.upArrowHeight} ${this.popWidth} ${this.upArrowHeight + this.radius}`;
    commands += `V${this.popHeight - this.radius} Q${this.popWidth} ${this.popHeight} ${this.popWidth -
    this.radius} ${this.popHeight}`;
    commands += `H${this.radius} Q0 ${this.popHeight} 0 ${this.popHeight - this.radius}`;
    commands += `V${this.radius + this.upArrowHeight} Q0 ${this.upArrowHeight} ${this.radius} ${this.upArrowHeight}`;
    return commands;
  }

  private getIconSize() {
    return EditModeUtils.convertWithDesktopScale(
      PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconSize * ICON_SCALE
    )
  }

  private getIconRadius() {
    return EditModeUtils.convertWithDesktopScale(
      PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconRadius * ICON_SCALE
    )
  }

  @Builder
  CancelButton() {
    Button({ type: ButtonType.Capsule, stateEffect: true }) {
      Text($r('app.string.cancel'))
        .draggable(false)
        .id(`${TAG}_Text_cancel`)
        .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_button1'), this.fontSizeScale))
        .fontColor($r('sys.color.font_emphasize'))
        .fontWeight(FontWeight.Medium)
    }
    .id(`${TAG}_Button_cancel`)
    .margin({ end: LengthMetrics.vp(StyleConstants.DEFAULT_4) })
    .backgroundColor(DIALOG_BUTTON_BG_COLOR)
    .height(StyleConstants.DEFAULT_40)
    .layoutWeight(1)
    .borderRadius(StyleConstants.DEFAULT_DIALOG_RADIUS)
    .onClick(() => {
      this.cancel?.();
      this.dealCancelDialogAnimation();
    })
  }

  @Builder
  ConfirmButton() {
    Button({ type: ButtonType.Capsule, stateEffect: true }) {
      Text(this.dialogConfig.confirmBtn)
        .draggable(false)
        .id(`${TAG}_Text_deleteOruninstall}`)
        .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_button1'), this.fontSizeScale))
        .fontColor(batchUninstallChain.currentMode === UninstallMode.NORMAL ? $r('sys.color.ohos_id_color_badge_red') :
        $r('sys.color.font_emphasize'))
        .fontWeight(FontWeight.Medium)
    }
    .id(`${TAG}_Button_uninstallOrSubmit`)
    .margin({ start: LengthMetrics.vp(StyleConstants.DEFAULT_4) })
    .backgroundColor(DIALOG_BUTTON_BG_COLOR)
    .height(StyleConstants.DEFAULT_40)
    .layoutWeight(1)
    .borderRadius(StyleConstants.DEFAULT_DIALOG_RADIUS)
    .onClick(() => {
      this.confirm?.();
      this.dealConfirmRemoveAnimation();
    })
  }

  @Builder
  DrawerUninstallButton() {
    Button({ type: ButtonType.Capsule, stateEffect: true }) {
      Text(this.dialogConfig.jumpBtn)
        .draggable(false)
        .id(`${TAG}_Text_remove}`)
        .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_button1'), this.fontSizeScale))
        .fontColor($r('sys.color.ohos_id_color_badge_red'))
        .fontWeight(FontWeight.Medium)
    }
    .id(`${TAG}_Button_Remove`)
    .margin({ start: LengthMetrics.vp(StyleConstants.DEFAULT_4) })
    .backgroundColor(DIALOG_BUTTON_BG_COLOR)
    .height(StyleConstants.DEFAULT_40)
    .layoutWeight(1)
    .borderRadius(StyleConstants.DEFAULT_DIALOG_RADIUS)
    .onClick(() => {
      this.jump2Uninstall?.();
    })
  }

  @Builder
  UninstallAppOrFormColumn() {
    Column() {
      // icon
      this.iconBuilder()
      // title
      this.titleBuilder()
      // content
      this.contentBuilder()

      if (batchUninstallChain.currentMode === UninstallMode.DRAWER) {
        // 从桌面移除
        Row() {
          this.ConfirmButton()
        }
        .alignItems(VerticalAlign.Center)
        .margin({ top: StyleConstants.DEFAULT_4 })
        // 卸载 APP
        if (batchUninstallChain.existsUninstallable) {
          Row() {
            this.DrawerUninstallButton()
          }
          .alignItems(VerticalAlign.Center)
          .margin({ top: StyleConstants.DEFAULT_4 })
        }
        // 取消
        Row() {
          this.CancelButton()
        }
        .alignItems(VerticalAlign.Center)
        .margin({ top: StyleConstants.DEFAULT_4 })
      } else {
        Flex({ alignItems: ItemAlign.Center }) {
          // cancelButton
          this.CancelButton()
          Divider()
            .vertical(true)
            .height(24)
            .strokeWidth(DIVIDER_WIDTH + 'px')
            .color($r('sys.color.comp_divider'))
            .margin({ left: 4, right: 4 })
          // confirmButton
          this.ConfirmButton()
        }
        .padding({
          start: LengthMetrics.vp(StyleConstants.DEFAULT_16),
          end: LengthMetrics.vp(StyleConstants.DEFAULT_16),
        })
      }
    }
    .backgroundColor($r('sys.color.ohos_id_color_mask_thin'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { policy: 1 }, { disableSystemAdaptation: true })
    .borderRadius(RADIUS)
    .padding({
      top: (this.isUninstallApp ? StyleConstants.DEFAULT_24 : StyleConstants.DEFAULT_16) + UP_ARROW_HEIGHT,
      bottom: batchUninstallChain.currentMode === UninstallMode.DRAWER ? StyleConstants.MARGIN_DEFAULT_8 :
      StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN
    })
    .width(px2vp(this.popWidth))
    .clip(new Path({
      commands: this.buildPopup()
    }))
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .scale({
      x: this.popScale,
      y: this.popScale,
      centerX: px2vp(this.centerX),
      centerY: 0
    })
    .opacity(this.dialogOpacity)
    .margin({
      top: LengthMetrics.vp(this.offsetY),
      end: this.isWideMode() ? LengthMetrics.vp(StyleConstants.DEFAULT_20) : LengthMetrics.vp(0),
    })
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      this.popHeight = vp2px(Number(newValue.height));
    })
  }

  @Builder
  contentBuilder() {
    Text(this.dialogConfig.content)
      .fontSize(EditModeUtils.getScaleSize(StyleConstants.DEFAULT_16, this.fontSizeScale))
      .margin({
        bottom: StyleConstants.DEFAULT_4
      })
      .padding({
        end: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_RIGHT_MARGIN),
        start: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_LEFT_MARGIN - 2),
      })
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.font_primary'))
  }

  @Builder
  titleBuilder() {
    Text(this.dialogConfig.title)
      .margin({
        top: StyleConstants.DEFAULT_8,
        bottom: StyleConstants.DEFAULT_8
      })
      .padding({
        end: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_RIGHT_MARGIN),
        start: LengthMetrics.vp(StyleConstants.DEFAULT_DIALOG_LEFT_MARGIN),
      })
      .fontWeight(FontWeight.Bold)
      .fontSize(EditModeUtils.getScaleSize(StyleConstants.DEFAULT_20, this.fontSizeScale))
      .fontColor($r('sys.color.font_primary'))
  }

  @Builder
  imageBuilder(n: number) {
    Image(this.dialogConfig.icons[n].icon)
      .backgroundImage(this.dialogConfig.icons[n].iconBG, { syncLoad: true } as BackgroundImageOptions)
      .backgroundImageSize(ImageSize.Cover)
      .backgroundImagePosition(Alignment.Center)
      .width(this.getIconSize())
      .height(this.getIconSize())
      .draggable(false)
      .clip(true)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .borderRadius(this.getIconRadius())
      .rotate({ angle: 10 * n })
  }

  @Builder
  iconBuilder() {
    Stack() {
      if (this.dialogConfig.icons.length > 1 && this.dialogConfig.icons[1].icon) {
        this.imageBuilder(1);
      }
      this.imageBuilder(0);
      // 分身应用需要展示分身角标
      if (this.dialogConfig.appIndex && this.dialogConfig.appIndex > 0) {
        Image($r(`app.media.app_icon_clone_index_${this.dialogConfig.appIndex}`))
          .height(APP_CLONE_BADGE_SIZE)
          .width(APP_CLONE_BADGE_SIZE)
          .enabled(false)
          .offset({
            x: APP_CLONE_BADGE_OFFSETX,
            y: APP_CLONE_BADGE_OFFSETY
          })
      }
    }
    .align(Alignment.BottomEnd)
    .margin({
      bottom: StyleConstants.DIVIDER_HEIGHT
    })
  }

  @Builder
  uninstallCustomDialogContent() {
    Column() {
      // icon
      this.iconBuilder()
      // title
      this.titleBuilder()
      // content
      this.contentBuilder()
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    if (this.editModeStyleConfig.uninstallDialogCustomDialogType === 'CustomContentDialog') {
      CustomContentDialog({
        contentBuilder: () => {
          this.uninstallCustomDialogContent();
        },
        buttons: [
          {
            value: $r('app.string.cancel'),
            action: () => {
              this.cancel?.();
            }
          },
          {
            value: this.dialogConfig.confirmBtn ?? $r('app.string.reConfirm_remove'),
            fontColor: $r('sys.color.ohos_id_color_warning'),
            action: () => {
              this.confirm?.();
            }
          }
        ]
      })
        .opacity(this.dialogOpacityEx.value)
    } else {
      Stack({ alignContent: this.isWideMode() ? Alignment.TopEnd : Alignment.Top }) {
        this.UninstallAppOrFormColumn()
      }
      .width(StyleConstants.PERCENTAGE_100)
      .opacity(this.dialogOpacityEx.value)
      .onAppear(() => {
        this.dealOpenAnimation();
      })
    }
  }
}