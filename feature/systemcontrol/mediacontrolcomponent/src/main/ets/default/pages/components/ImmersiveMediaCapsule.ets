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
  immersiveKgMgr,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { CapWgBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { MediaImmersiveConstants } from '../../Util/MediaImmersiveConstants';
import { FadeCapsuleTextView } from './FadeCapsuleTextView';
import { CardMediaController } from '../../Controller/CardMediaController';
import AVSessionManager from '@ohos.multimedia.avsession';
import { globalStorage } from '../../Util/GlobalStorage';
import { AccessibilityAppName } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { AnimationState } from '../../viewmodel/AnimationState';
import { AnimationController } from '../../Controller/AnimationController';
import { ButtonIconName } from '../../Util/Constants';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG = 'ImmersiveMediaCapsule';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct ImmersiveMediaCapsule {

  @StorageLink('ControlMediaTitle') title: string = '';
  @StorageLink('MediaArtist') artist: string = '';
  @StorageLink('MediaImg') image: string | PixelMap = '';
  @StorageLink('MediaImgShow') mediaImgShow: boolean = false;
  @StorageLink('MediaPlayState') @Watch('mediaStateUpdate') playState: number = 0;
  @StorageLink('appName') appName: string = '';
  @StorageLink('MediaValidCommands') @Watch('onValidCommandsChange') validCommands: Array<string> = [];
  @State isShowPlayButton: boolean = false;
  @State sysConfigData: SysConfigData =
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private controller: CardMediaController = CardMediaController.getInstance();
  @State @Watch('onIsMarqueeStart') isMarqueeStart: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State recentlyPlayTitle: string = ResUtils.getInnerString($r('app.string.RecentlyPlay'));
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  /**
   * 是否响应事件
   */
  private isEnabled: boolean = true;

  /**
   * 胶囊高度
   */
  @Prop capHeight: number | string;

  /**
   * 胶囊宽度
   */
  @Prop capWidth: number | string = '100%';

  /**
   * 胶囊文本透明度
   */
  @Prop textAlpha: number | undefined;


  // 胶囊UI绑定状态
  @State capBindSt?: ISlState = slUiStateMgr.getSlState(SlMainStateType.SL_CAP_WG_BIND_STATE);

  /**
   * 锁屏一镜到底动效状态
   */
  @State mediaAnimState: AnimationState = AnimationController.getAnimationState();

  /**
   * 根据壁纸计算是否压暗
   */
  @Prop isDarken: boolean = false;

  private isAnimeComponent = false;

  @State isPlaying: boolean = false;

  @State isPlayButtonVisible: boolean = false;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear isAnime ${this.isAnimeComponent}`);
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      this.onScreenOnOffEvent(event)
    });
    let isCurScreenOn: boolean | undefined = AppStorage.get('isCurScreenOn');
    if (isCurScreenOn) {
      this.isMarqueeStart = true;
    }
    this.mediaStateUpdate();
    this.onValidCommandsChange();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear isAnime ${this.isAnimeComponent}`);
    this.eventMgr.offAll();
  }

  onValidCommandsChange() {
    this.isShowPlayButton = this.validCommands?.includes('play');
  }

  mediaStateUpdate() {
    this.isPlaying = this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
      this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING;
  }

  isHasMediaImage() {
    return !!this.image && this.image != 'unknown' && this.mediaImgShow && !this.image?.toString()?.includes('http')
  }

  hasMediaBackground(): number | Resource | Color | undefined {
    return this.isHasMediaImage() ? Color.Transparent :$r('app.color.menu_divider_color_dark')
  }

  isRTL() {
    return !!this.sysConfigData?.isRTL;
  }

  build() {
    Row() {
      AccessibilityAppName({
        name: this.appName,
        isAccessibilityMode: this.isAccessibilityMode
      })
      // 图标区域
      Stack() {
        Column()
          .width(MediaImmersiveConstants.CAPSULE_ICON_SPECS)
          .height(MediaImmersiveConstants.CAPSULE_ICON_SPECS)
          .backgroundColor(this.hasMediaBackground())
          .borderRadius(MediaImmersiveConstants.CAPSULE_EXTEND_ICON_RADIUS)
        if (this.mediaAnimState.isCapsuleShow) {
          Image(this.image || $r('app.media.ic_nomusic_img'))
            .alt($r('app.media.ic_nomusic_img'))
            .width(MediaImmersiveConstants.CAPSULE_ICON_SPECS)
            .height(MediaImmersiveConstants.CAPSULE_ICON_SPECS)
            .fillColor(MediaImmersiveConstants.getMainTextFontColor())
            .objectFit(ImageFit.Cover)
            .draggable(false)
            .borderRadius(MediaImmersiveConstants.CAPSULE_EXTEND_ICON_RADIUS)
            .interpolation(ImageInterpolation.Medium)
            .id('mediaControllerImage_capsule')
            .geometryTransition(this.mediaAnimState.isCapsuleGeo && !this.isAnimeComponent ?
              'mediaControllerImage' : '', {hierarchyStrategy: TransitionHierarchyStrategy.ADAPTIVE})
            .transition(TransitionEffect.IDENTITY)
            .zIndex(100)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
      }
      .opacity(undefined)
      .width(MediaImmersiveConstants.getIconAreaSpecs())
      .height(MediaImmersiveConstants.getIconAreaSpecs())

      // 文本区域
      this.FadeCapsuleTextArea()

      // 按钮区域
      Button() {
        Stack() {
          Column()
            .width(MediaImmersiveConstants.CAPSULE_EXTEND_SPECS)
            .height(MediaImmersiveConstants.CAPSULE_EXTEND_SPECS)
            .borderRadius(MediaImmersiveConstants.CAPSULE_EXTEND_SPECS / 2)
            .backgroundColor($r('app.color.menu_divider_color_dark'))
          SymbolGlyph(this.isPlaying ? $r(ButtonIconName.PAUSE_SYMBOL) : $r(ButtonIconName.PLAY_SYMBOL))
            .fontColor([MediaImmersiveConstants.getMainTextFontColor()])
            .fontSize('20vp')
            .foregroundBrightness(MediaImmersiveConstants.getMainTextBrightColor(this.isDarkMode()))
            .draggable(false)
            .rotate({ angle: this.isRTL() ? 180 : 0 })
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isPlayButtonVisible)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
      }
      .stateEffect(false)
      .draggable(false)
      .size({width : '100%', height : '100%'})
      .clip(false)
      .width(MediaImmersiveConstants.CAPSULE_EXTEND_SPECS)
      .height(MediaImmersiveConstants.CAPSULE_EXTEND_SPECS)
      .margin({
        top: MediaImmersiveConstants.CAPSULE_EXTEND_TOP_MARGIN,
        bottom: MediaImmersiveConstants.CAPSULE_EXTEND_BOTTOM_MARGIN,
        left: MediaImmersiveConstants.CAPSULE_EXTEND_LEFT_MARGIN,
        right: MediaImmersiveConstants.CAPSULE_EXTEND_RIGHT_MARGIN
      })
      .opacity(this.textAlpha)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        log.showInfo(`onclick isplaying ${this.playState}`);
        if (!this.isShowPlayButton) {
          log.showInfo(`playButton is invalid`);
          return;
        }
        log.showInfo(`playButton is invalid ${this.isShowPlayButton}`);
        globalStorage.setStringByKey('scenesType', 'capsule');
        if (AppStorage.get('isNotificationFromDeviceChange')) {
          this.controller.startHistoryApp();
        } else if (this.isPlaying) {
          this.controller.callShowingPause();
        } else {
          this.controller.callShowingPlay(false);
        }
      })
      .onVisibleAreaChange([0, 1], (isVisible: boolean, currentRatio: number) => {
        if (isVisible && currentRatio >= 1 && !this.isPlayButtonVisible) {
          this.isPlayButtonVisible = true;
        }
        if (!isVisible && currentRatio <= 0 && this.isPlayButtonVisible) {
          this.isPlayButtonVisible = false;
        }
      })
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .accessibilityText(this.isPlaying ? ResUtils.getInnerString($r('app.string.access_pause')) :
      ResUtils.getInnerString($r('app.string.access_play')))
    }
    .enabled(this.isEnabled)
    .width(this.capWidth).height(this.capHeight)
  }

  @Builder
  FadeCapsuleTextArea() {
    Column({space: 2}) {
      // 主文本区域
      FadeCapsuleTextView({
        text: this.title || this.appName || this.recentlyPlayTitle,
        isStartMarquee: this.isPlaying && this.isMarqueeStart,
        fontSize: MediaImmersiveConstants.CAPSULE_MAIN_TEXT_FONT_SIZE,
        fontWeight: FontWeight.Medium,
        fontColor: MediaImmersiveConstants.getMainTextFontColor(),
        foreGroundBrightness: MediaImmersiveConstants.getMainTextBrightColor(this.isDarkMode()),
      }).height((this.fontSizeScale === 1) ? 21 : 23)

      // 次文本区域
      FadeCapsuleTextView({
        text: this.artist,
        isStartMarquee: this.isPlaying && this.isMarqueeStart,
        fontSize: MediaImmersiveConstants.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
        fontWeight: FontWeight.Regular,
        fontColor: MediaImmersiveConstants.getSecondaryTextFontColor(),
        foreGroundBrightness: MediaImmersiveConstants.getSecondaryBrightColor(this.isDarkMode()),
      })
        .height((this.fontSizeScale === 1) ? 16 : 19)
        .visibility(this.artist ? Visibility.Visible : Visibility.None)
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .height(MediaImmersiveConstants.getCapsuleHeight())
    .opacity(this.textAlpha)
  }

  onIsMarqueeStart() {
    log.showInfo(`isMarqueeStartChange: ${this.isMarqueeStart}`);
  }

  onScreenOnOffEvent(event: ScreenOnOffEvent) {
    log.showInfo('onScreenOnOffEvent: ' + JSON.stringify(event));
    if (event.event == 'usual.event.SCREEN_OFF') {
      this.isMarqueeStart = false;
    }
    if (event.event == 'usual.event.SCREEN_ON') {
      this.isMarqueeStart = true;
    }
  }

  private isDarkMode(): boolean {
    // 压暗模式
    return (this.capBindSt?.getSlState(CapWgBindStateType.PT_CAP_DARK_MODE) as boolean) ?? false;
  }
}
