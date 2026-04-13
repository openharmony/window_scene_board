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

import { ConfigurationConstant } from '@kit.AbilityKit';
import Curves from '@ohos.curves';
import { LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext, sEventManager } from '@ohos/frameworkwrapper';
import { ScreenLockStatus } from '@ohos/screenlockcommon/src/main/ets/interface/ScreenOnOffMediator';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { sMultimediaSubPageLayoutController } from '../../controller/MultimediaSubPageLayoutController';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import { PrivacySensorViewData } from '../../model/PrivacySensorViewData';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { ControlCenterMultimediaType, PrivacySensorViewModel } from '../../viewModel/PrivacySensorViewModel';

const TAG: string = 'Ctrl.MultimediaSubPageLayout';
const log: Logger = Logger.getLogHelper(LogDomain.CC);

const DEFAULT_WIDTH: number = 312;
const DEFAULT_HEIGHT: number = 398;
const CARD_SPACE: number = 12;
const TITLE_BAR_HEIGHT: number = 64;
const TITLE_BAR_TEXT_SPACE: number = 16;
const TITLE_BAR_LEFT_PADDING: number = 20;
const TITLE_BAR_RIGHT_PADDING: number = 16;
const TITLE_BAR_ICON_SIZE: number = 24;
const BRACKET_KIT_CONTENT_HEIGHT: number = 124;
const SOUND_EFFECT_CONTENT_HEIGHT: number = 108;
const VIDEO_EFFECT_CONTENT_HEIGHT: number = 108;

@Component
export struct MultimediaSubPageLayout {
  private windowWidth: number = DEFAULT_WIDTH;
  private windowHeight: number = DEFAULT_HEIGHT;
  @Link contentHeight: number | string;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @Consume @Watch('updateCardExpand') privacySensorData: PrivacySensorViewData;
  private viewModel: PrivacySensorViewModel = PrivacySensorViewModel.getInstance(this.privacySensorData);
  @StorageProp('currColorMode') @Watch('updateLabelIcon') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  @State isShowExtension: boolean = true;
  @State isShowTriangle: boolean = false;
  @State gimbalControlIcon: Resource = $r('app.media.ic_gimbal_control');
  @State soundEffectIcon: Resource = $r('app.media.ic_sound_effect');
  @State videoEffectIcon: Resource = $r('app.media.ic_video_effect');
  @State triangleFoldIcon: Resource = $r('app.media.ic_triangle_fold');
  @State triangleUnfoldIcon: Resource = $r('app.media.ic_triangle_unfold');
  @State isBracketKitCardExpand: boolean = true;
  @State isSoundEffectCardExpand: boolean = false;
  @State isVideoEffectCardExpand: boolean = false;

  private backToMainPage(event?: TouchEvent) {
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      sMultimediaSubPageLayoutController.hideWindow();
    }
  }

  aboutToAppear(): void {
    log.showInfo(TAG, 'aboutToAppear');
    if (ScreenLockAdapter.getLock()) {
      this.isShowExtension = false;
    } else {
      this.isShowExtension = true;
    }
    this.updateCardExpand();
    this.updateLabelIcon();
    log.showDebug(TAG, `aboutToAppear this.isShowExtension: ${this.isShowExtension}`);
    // UIE加载锁屏状态监听
    sEventManager.subscribe('ControlCenterLockStatus', this.onLockStatusChanged);
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    sEventManager.off('ControlCenterLockStatus', this.onLockStatusChanged);
  }

  private onLockStatusChanged = (lockStatus: ScreenLockStatus): void => {
    log.showInfo(TAG, `onLockStatusChanged lock status: ${lockStatus}`);
    if (lockStatus === ScreenLockStatus.UNLOCK) {
      this.isShowExtension = true;
    } else {
      this.isShowExtension = false;
    }
    log.showDebug(TAG, `onLockStatusChanged this.isShowExtension: ${this.isShowExtension}`);
  }

  build() {
    Stack() {
      this.loadBlankStack()
      Stack() {
        this.loadBlankStack()
        if (this.isShowExtension) {
          this.loadCards();
        }
      }
      .width(this.windowWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' : this.contentHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelMargin)
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
  }

  @Builder
  loadBlankStack() {
    Stack()
      .width('100%')
      .height('100%')
      .onTouch((event) => {
        this.backToMainPage(event);
      })
  }

  @Builder
  loadCards() {
    List({ space: CARD_SPACE }) {
      if (this.privacySensorData.multimediaSensorTypeArray[ControlCenterMultimediaType.BRACKET_KIT.valueOf()]) {
        this.cardItem(ControlCenterMultimediaType.BRACKET_KIT);
      }
      if (this.privacySensorData.multimediaSensorTypeArray[ControlCenterMultimediaType.SOUND_EFFECT.valueOf()]) {
        this.cardItem(ControlCenterMultimediaType.SOUND_EFFECT);
      }
      if (this.privacySensorData.multimediaSensorTypeArray[ControlCenterMultimediaType.VIDEO_EFFECT.valueOf()]) {
        this.cardItem(ControlCenterMultimediaType.VIDEO_EFFECT);
      }
    }
    .alignListItem(ListItemAlign.Center)
    .scrollBar(BarState.Off)
    .contentEndOffset(this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ? 64 : 0)
    .clip(false)
  }

  @Builder
  cardItem(type: ControlCenterMultimediaType) {
    ListItem() {
      if (type === ControlCenterMultimediaType.BRACKET_KIT) {
        this.bracketKitCard();
      } else if (type === ControlCenterMultimediaType.SOUND_EFFECT) {
        this.soundEffectCard();
      } else if (type === ControlCenterMultimediaType.VIDEO_EFFECT) {
        this.videoEffectCard();
      }
    }
    .height(this.getCardHeight(type))
    .animation({
      curve: Curves.interpolatingSpring(0, 1, 228, 22),
    })
  }

  @Builder
  titleBar(type: ControlCenterMultimediaType) {
    Row({ space: 12 }) {
      Row({ space: TITLE_BAR_TEXT_SPACE } ) {
        if (type === ControlCenterMultimediaType.BRACKET_KIT) {
          Image(this.gimbalControlIcon).iconStyle()
        } else if (type === ControlCenterMultimediaType.SOUND_EFFECT) {
          Image(this.soundEffectIcon).iconStyle()
        } else if (type === ControlCenterMultimediaType.VIDEO_EFFECT) {
          Image(this.videoEffectIcon).iconStyle()
        }

        Column({ space: 2 }) {
          Text(this.getTitleText(type))
            .fontSize($r('sys.float.Subtitle_M'))
            .fontWeight(FontWeight.Bold)
            .fontFamily('HarmonyHeiTi')
            .fontColor(this.colorModeViewData.subpageBrightnessTitleColor)
            .maxFontScale(1.75)
            .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
              this.colorModeViewData.foregroundPrimaryOptionOnBackground))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width(152)
        .alignItems(HorizontalAlign.Start)
      }

      if (this.isShowTriangle) {
        Row() {
          Image(this.isCurrentCardExpand(type) ? this.triangleUnfoldIcon : this.triangleFoldIcon)
            .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
              this.colorModeViewData.foregroundPrimaryOptionOnBackground))
        }
        .size({ height: 24, width: 24 })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height(TITLE_BAR_HEIGHT)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: TITLE_BAR_LEFT_PADDING, right: TITLE_BAR_RIGHT_PADDING })
    .opacity(this.backgroundOpacity.backgroundOpacity)
    .onClick(() => {
      this.updateCardExpand(type);
    })
  }

  @Builder
  bracketKitCard() {
    Column() {
      this.titleBar(ControlCenterMultimediaType.BRACKET_KIT)

      if (this.isBracketKitCardExpand) {
        UIExtensionComponent(
          {
            bundleName: 'com.ohos.dhardwareui',
            abilityName: 'MechExtAbility',
            parameters: {
              'ability.want.params.uiExtensionType': 'sys/commonUI',
            }
          })
          .height(BRACKET_KIT_CONTENT_HEIGHT)
          .UIEStyle()
      }
    }
    .visibility(this.backgroundOpacity?.backgroundOpacity !== 0 ? Visibility.Visible : Visibility.Hidden)
    .cardStyle()
    .geometryTransition(`bracketKitCard`)
  }

  @Builder
  soundEffectCard() {
    Column() {
      this.titleBar(ControlCenterMultimediaType.SOUND_EFFECT)

      if (this.isSoundEffectCardExpand) {
        UIExtensionComponent(
          {
            bundleName: 'com.ohos.mediacontroller',
            abilityName: 'LiveEffectSelectAbility',
            parameters: {
              'ability.want.params.uiExtensionType': 'sys/commonUI',
            }
          })
          .height(SOUND_EFFECT_CONTENT_HEIGHT)
          .UIEStyle()
      }
    }
    .visibility(this.backgroundOpacity?.backgroundOpacity !== 0 ? Visibility.Visible : Visibility.Hidden)
    .cardStyle()
    .geometryTransition(`soundEffectCard`)
  }

  @Builder
  videoEffectCard() {
    Column() {
      this.titleBar(ControlCenterMultimediaType.VIDEO_EFFECT)

      if (this.isVideoEffectCardExpand) {
        UIExtensionComponent(
          {
            bundleName: 'com.ohos.camera',
            abilityName: 'com.ohos.camera.VideoEffectsExtAbility',
            moduleName: 'picker',
            parameters: {
              'ability.want.params.uiExtensionType': 'sys/commonUI',
            }
          })
          .height(VIDEO_EFFECT_CONTENT_HEIGHT)
          .UIEStyle()
          .onReceive(sMultimediaSubPageLayoutController.onRemoteReceive)
          .onRemoteReady(sMultimediaSubPageLayoutController.onRemoteReady)
      }
    }
    .cardStyle()
    .geometryTransition(`videoEffectCard`)
  }

  @Styles
  cardStyle() {
    .width('100%')
    .height('100%')
    .borderRadius(32)
    .backgroundColor(this.backgroundOpacity?.backgroundOpacity !== 0 ?
      $r('app.color.ntf_brightness_bg_color') : Color.Transparent)
    .backgroundBrightnessInternal(this.backgroundOpacity?.backgroundOpacity !== 0 ?
      this.colorModeViewData.mainCardOption : undefined)
    .clip(true)
    .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageMargin)
  }

  @Styles
  UIEStyle() {
    .width('100%')
    .backgroundColor(this.backgroundOpacity?.backgroundOpacity !== 0 ?
      $r('app.color.theme_ntf_phone_action_bg_color') : Color.Transparent)
    .backgroundBrightnessInternal(this.backgroundOpacity?.backgroundOpacity !== 0 ?
      this.colorModeViewData.customActionViewBg : undefined)
  }

  @Styles
  iconStyle() {
    .width(TITLE_BAR_ICON_SIZE)
    .height(TITLE_BAR_ICON_SIZE)
    .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
      this.colorModeViewData.foregroundPrimaryOptionOnBackground))
  }

  private getTitleText(type: ControlCenterMultimediaType): string | undefined {
    if (type === ControlCenterMultimediaType.BRACKET_KIT) {
      return ResUtils.getInnerString($r('app.string.multimedia_sensor_bracket_kit'));
    }
    if (type === ControlCenterMultimediaType.SOUND_EFFECT) {
      return ResUtils.getInnerString($r('app.string.multimedia_sensor_sound_effects'));
    }
    if (type === ControlCenterMultimediaType.VIDEO_EFFECT) {
      return ResUtils.getInnerString($r('app.string.multimedia_sensor_video_effects'));
    }
    return undefined;
  }

  private getCardHeight(type: ControlCenterMultimediaType): number {
    switch (type) {
      case ControlCenterMultimediaType.BRACKET_KIT:
        return TITLE_BAR_HEIGHT + (this.isBracketKitCardExpand ? BRACKET_KIT_CONTENT_HEIGHT : 0);
      case ControlCenterMultimediaType.SOUND_EFFECT:
        return TITLE_BAR_HEIGHT + (this.isSoundEffectCardExpand ? SOUND_EFFECT_CONTENT_HEIGHT : 0);
      case ControlCenterMultimediaType.VIDEO_EFFECT:
        return TITLE_BAR_HEIGHT + (this.isVideoEffectCardExpand ? VIDEO_EFFECT_CONTENT_HEIGHT : 0);
      default:
        return TITLE_BAR_HEIGHT;
    }
  }

  private updateCardExpand(type?: ControlCenterMultimediaType): void {
    if (this.viewModel.getMultimediaSensorIconCount() < 3) {
      this.isBracketKitCardExpand = this.privacySensorData.multimediaSensorTypeArray[
        ControlCenterMultimediaType.BRACKET_KIT.valueOf()];
      this.isSoundEffectCardExpand = this.privacySensorData.multimediaSensorTypeArray[
        ControlCenterMultimediaType.SOUND_EFFECT.valueOf()];
      this.isVideoEffectCardExpand = this.privacySensorData.multimediaSensorTypeArray[
        ControlCenterMultimediaType.VIDEO_EFFECT.valueOf()];
      this.isShowTriangle = false;
      return;
    }
    if (type !== undefined) {
      switch (type) {
        case ControlCenterMultimediaType.BRACKET_KIT:
          this.isBracketKitCardExpand = !this.isBracketKitCardExpand;
          if (this.isBracketKitCardExpand) {
            this.isSoundEffectCardExpand = false;
            this.isVideoEffectCardExpand = false;
          }
          break;
        case ControlCenterMultimediaType.SOUND_EFFECT:
          this.isSoundEffectCardExpand = !this.isSoundEffectCardExpand;
          if (this.isSoundEffectCardExpand) {
            this.isBracketKitCardExpand = false;
            this.isVideoEffectCardExpand = false;
          }
          break;
        case ControlCenterMultimediaType.VIDEO_EFFECT:
          this.isVideoEffectCardExpand = !this.isVideoEffectCardExpand;
          if (this.isVideoEffectCardExpand) {
            this.isBracketKitCardExpand = false;
            this.isSoundEffectCardExpand = false;
          }
          break;
        default:
          break;
      }
      return;
    }
    if (this.backgroundOpacity?.backgroundOpacity === 0) {
      this.isBracketKitCardExpand = false;
      this.isSoundEffectCardExpand = false;
      this.isVideoEffectCardExpand = true;
    } else {
      this.isBracketKitCardExpand = true;
      this.isSoundEffectCardExpand = false;
      this.isVideoEffectCardExpand = false;
    }
    this.isShowTriangle = true;
  }

  private updateLabelIcon(): void {
    log.showInfo(TAG, `currColorMode changed to ${this.currColorMode}`);
    if (this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.triangleFoldIcon = $r('app.media.ic_triangle_fold_dark');
      this.triangleUnfoldIcon = $r('app.media.ic_triangle_unfold_dark');
      this.gimbalControlIcon = $r('app.media.ic_gimbal_control_dark');
      this.soundEffectIcon = $r('app.media.ic_sound_effect_dark');
      this.videoEffectIcon = $r('app.media.ic_video_effect_dark');
    } else {
      this.triangleFoldIcon = $r('app.media.ic_triangle_fold');
      this.triangleUnfoldIcon = $r('app.media.ic_triangle_unfold');
      this.gimbalControlIcon = $r('app.media.ic_gimbal_control');
      this.soundEffectIcon = $r('app.media.ic_sound_effect');
      this.videoEffectIcon = $r('app.media.ic_video_effect');
    }
  }

  private isCurrentCardExpand(type: ControlCenterMultimediaType): boolean {
    switch (type) {
      case ControlCenterMultimediaType.BRACKET_KIT:
        return this.isBracketKitCardExpand;
      case ControlCenterMultimediaType.SOUND_EFFECT:
        return this.isSoundEffectCardExpand;
      case ControlCenterMultimediaType.VIDEO_EFFECT:
        return this.isVideoEffectCardExpand;
      default:
        return false;
    }
  }
}
