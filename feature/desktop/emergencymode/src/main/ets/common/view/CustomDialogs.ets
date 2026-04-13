/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { DeviceHelper, ScreenState } from '@ohos/frameworkwrapper';
import { DesktopModeEnum, DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { EmergencyUtils } from '../../../../..';
// import lazy { OuterCommonConstants } from '../../smallfold/OuterCommonConstants';
// import lazy { OuterEmergencyUtils } from '../../smallfold/OuterEmergencyUtils';
import { DialogConstants } from '../CommonConstants';
import { CommonUtils } from '../CommonUtils';

const TAG = 'CustomDialogs';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@CustomDialog
export struct ExitEMCCustomDialog {
  controller: CustomDialogController;
  title: string = '';
  content: string = '';
  leftButton: string = '';
  rightButton: string = '';
  @State titleLines: number = 1;
  @State contentLines: number = 1;
  @Link @Watch('updateStates') mScreenState: ScreenState;
  @State dialogWidth: number = Math.min(EmergencyUtils.getScreenWidth() -
    DialogConstants.DIALOG_MARIN, DialogConstants.DIALOG_MAX_WIDTH);
  @State buttonWidth: number = this.getButtonWidth();

  aboutToAppear(): void {
    this.updateStates();
  }

  private updateStates(): void {
    this.dialogWidth = Math.min(
      EmergencyUtils.getScreenWidth() - DialogConstants.DIALOG_MARIN, DialogConstants.DIALOG_MAX_WIDTH);
    this.buttonWidth = this.getButtonWidth();
    this.titleLines = CommonUtils.calTextLines($r(this.title),
      DialogConstants.DIALOG_TITLE_FONT_SIZE, FontWeight.Bold, (
        this.dialogWidth - (DialogConstants.DIALOG_PADDING * 2)));
    this.contentLines = CommonUtils.calTextLines($r(this.content), DialogConstants.ENTER_TITLE_FONT_SIZE,
      FontWeight.Medium, (this.dialogWidth - (DialogConstants.DIALOG_PADDING * 2)));
  }

  private getButtonWidth(): number {
    return (this.dialogWidth - (DialogConstants.DIALOG_PADDING * 2) -
      DialogConstants.DIALOG_BLANK_WIDTH - (DialogConstants.DIALOG_BLANK_MARGIN) * 2) / 2;
  }

  build() {
    WithTheme({ colorMode: ThemeColorMode.DARK }) {
      Stack() {
        Column() {
        }
        .height(DialogConstants.TITLE_HEIGHT + (DialogConstants.ENTER_TITLE_LINE_HEIGHT * this.contentLines) +
          DialogConstants.BUTTON_TOTAL_HEIGHT + DialogConstants.BUTTON_TOTAL_MARGIN_TOP)
        .width(this.dialogWidth)
        .backdropBlur(DialogConstants.DIALOG_BACKGROUND_BLUR, undefined, { disableSystemAdaptation: true })
        .borderRadius(DialogConstants.DIALOG_RADIUS)

        Column() {
          Text($r(this.title))
            .textAlign(TextAlign.Center)
            .textStyle(DialogConstants.DIALOG_TITLE_FONT_SIZE, FontWeight.Bold, '#FFFFFF',
              DialogConstants.ENTER_TITLE_LINE_HEIGHT)
            .height(DialogConstants.TITLE_HEIGHT)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .maxFontScale(1)
          Text($r(this.content))
            .textStyle(DialogConstants.ENTER_TITLE_FONT_SIZE, FontWeight.Medium, '#FFFFFF',
              DialogConstants.ENTER_CONTENT_LINE_HEIGHT)
            .textAlign(TextAlign.Center)
            .maxFontScale(1)

          Row() {
            Text($r(this.leftButton))
              .textStyle(DialogConstants.ENTER_TITLE_FONT_SIZE, FontWeight.Medium, '#5291FF',
                DialogConstants.ENTER_CONTENT_LINE_HEIGHT)
              .width(this.buttonWidth)
              .align(Alignment.Center)
              .textAlign(TextAlign.Center)
              .clickEffect({
                level: ClickEffectLevel.LIGHT
              })
              .onClick(() => {
                // EmergencyViewModel.getInstance().exitEmergency();
                this.controller.close();
              })
              .height(DialogConstants.DIALOG_BUTTON_HEIGHT)
              .maxFontScale(1)

            Blank()
              .height(DialogConstants.DIALOG_BLANK_HEIGHT)
              .width(DialogConstants.DIALOG_BLANK_WIDTH)
              .color($r('sys.color.comp_divider'))
              .align(Alignment.Center)
              .margin({
                left: DialogConstants.DIALOG_BLANK_MARGIN,
                right: DialogConstants.DIALOG_BLANK_MARGIN,
                top: DialogConstants.DIALOG_BLANK_MARGIN
              })
            Text($r(this.rightButton))
              .textStyle(DialogConstants.ENTER_TITLE_FONT_SIZE, FontWeight.Medium, '#5291FF',
                DialogConstants.ENTER_TITLE_LINE_HEIGHT)
              .width(this.buttonWidth)
              .align(Alignment.Center)
              .textAlign(TextAlign.Center)
              .clickEffect({
                level: ClickEffectLevel.LIGHT
              })
              .onClick(() => {
                this.controller.close();
              })
              .height(DialogConstants.DIALOG_BUTTON_HEIGHT)
              .maxFontScale(1)
          }
          .alignItems(VerticalAlign.Top)
          .width('100%')
          .height(DialogConstants.BUTTON_TOTAL_HEIGHT)
          .margin({
            top: DialogConstants.DIALOG_BLANK_MARGIN
          })
        }
        .width(this.dialogWidth)
        .padding({
          left: DialogConstants.DIALOG_PADDING, right: DialogConstants.DIALOG_PADDING
        })
        .backgroundColor(DialogConstants.BACKGROUND_COLOR)
        .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
      }
    }
  }
}

@CustomDialog
export struct EnterCustomDialog {
  controller: CustomDialogController;
  @Prop titleDialog: string;
  contentDialog: string = '';
  @State contentLines: number = 1;
  @State radioIconPath: string = DialogConstants.RESOURCE_PATH_RADIO_ENABLED;
  isSelectedNotRemind: boolean = false;
  @Link @Watch('updateStates') mScreenState: ScreenState;
  @State dialogWidth: number = Math.min(EmergencyUtils.getScreenWidth() -
    DialogConstants.DIALOG_MARIN, DialogConstants.DIALOG_MAX_WIDTH);
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  aboutToAppear(): void {
    this.updateStates();
  }

  private updateStates(): void {
    this.dialogWidth = Math.min(
      EmergencyUtils.getScreenWidth() - DialogConstants.DIALOG_MARIN, DialogConstants.DIALOG_MAX_WIDTH);
    this.contentLines = CommonUtils.calTextLines($r(this.contentDialog), DialogConstants.ENTER_TITLE_FONT_SIZE,
      FontWeight.Medium, (this.dialogWidth - (DialogConstants.DIALOG_PADDING * 2)));
  }

  @Builder
  radioBuilder() {
    Image($r(this.radioIconPath))
      .width(DialogConstants.RADIO_ICON_SIZE)
      .height(DialogConstants.RADIO_ICON_SIZE)
      .onClick(this.radioButtonClick)
    Text($r('app.string.Emergency_dialog_not_remind'))
      .textStyle(DialogConstants.ENTER_REMIND_FONT_SIZE, FontWeight.Regular, '#FFFFFF', DialogConstants.ENTER_REMIND_LINE_HEIGHT)
      .maxFontScale(1)
  }

  private radioButtonClick = (): void => {
    if (this.isSelectedNotRemind) {
      this.isSelectedNotRemind = false;
      this.radioIconPath = DialogConstants.RESOURCE_PATH_RADIO_ENABLED;
    } else {
      this.isSelectedNotRemind = true;
      this.radioIconPath = DialogConstants.RESOURCE_PATH_RADIO_SELECT;
    }
  }

  build() {
    WithTheme({ colorMode: ThemeColorMode.DARK }) {
      Stack() {
        Column() {
        }
        .height(DialogConstants.TITLE_HEIGHT + (DialogConstants.ENTER_TITLE_LINE_HEIGHT * this.contentLines) +
          DialogConstants.BUTTON_TOTAL_HEIGHT + DialogConstants.BUTTON_TOTAL_MARGIN_TOP)
        .width(this.dialogWidth)
        .backdropBlur(DialogConstants.DIALOG_BACKGROUND_BLUR, undefined, { disableSystemAdaptation: true })
        .borderRadius(DialogConstants.DIALOG_RADIUS)

        Column() {
          Text($r(this.titleDialog))
            .textAlign(TextAlign.Center)
            .textStyle(DialogConstants.DIALOG_TITLE_FONT_SIZE, FontWeight.Bold, '#FFFFFF',
              DialogConstants.ENTER_TITLE_LINE_HEIGHT)
            .height(DialogConstants.TITLE_HEIGHT)
            .textAlign(TextAlign.Center)
            .maxFontScale(1)
          Text($r(this.contentDialog))
            .textStyle(DialogConstants.ENTER_TITLE_FONT_SIZE, FontWeight.Medium, '#FFFFFF',
              DialogConstants.ENTER_CONTENT_LINE_HEIGHT)
            .textAlign(this.contentLines > 1 ? TextAlign.Start : TextAlign.Center)
            .maxFontScale(1)

          Row() {
            Text($r('app.string.Emergency_button_know'))
              .textStyle(DialogConstants.ENTER_TITLE_FONT_SIZE, FontWeight.Medium,
                $r('sys.color.ohos_id_color_text_primary_activated'), DialogConstants.ENTER_CONTENT_LINE_HEIGHT)
              .textAlign(TextAlign.Center)
              .clickEffect({
                level: ClickEffectLevel.LIGHT
              })
              .onClick(() => {
                if (this.isSelectedNotRemind) {
                  if (DesktopModeManager.getInstance().getDesktopMode() === DesktopModeEnum.EMERGENCY_MODE) {
                    // EmergencyViewModel.getInstance().updateEnterDialogFlag();
                  } else if (DesktopModeManager.getInstance().getDesktopMode() === DesktopModeEnum.THERMAL_SAFE_MODE) {
                    // ThermalSafeViewModel.getInstance().updateEnterDialogFlag();
                  }
                }
                this.controller.close();
              })
              .height(DialogConstants.DIALOG_BUTTON_HEIGHT)
              .maxFontScale(1)
          }
          .alignItems(VerticalAlign.Top)
          .height(DialogConstants.BUTTON_TOTAL_HEIGHT)
          .margin({
            top: DialogConstants.BUTTON_TOTAL_MARGIN_TOP
          })
          .pixelRound({
            top: PixelRoundCalcPolicy.FORCE_CEIL
          })
          .width('100%')
        }
        .width(this.dialogWidth)
        .padding({
          left: DialogConstants.DIALOG_PADDING, right: DialogConstants.DIALOG_PADDING
        })
        .backgroundColor(DialogConstants.BACKGROUND_COLOR)
        .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
      }
    }
  }
}

@Extend(Text)
function textStyle(fontSize: number, fontWeight: FontWeight, fontColor: string | ResourceColor, lineHeight: number) {
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
  .lineHeight(lineHeight)
  .fontFamily('HarmonyHeiTi')
  .width('100%')
}