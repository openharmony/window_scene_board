/*
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import AnimationIconLocal from './AnimationIconLocal';
import avSession from '@ohos.multimedia.avsession';
import { CardMediaController } from '../../Controller/CardMediaController';
import { CardMediaControllerDc } from '../../Controller/CardMediaControllerDc';
import { DcMediaController } from '../../Controller/DcMediaController';
import {
  AodStyleType,
  ImmersiveAodStyle,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import {
  immersiveKgMgr,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { globalStorage } from '../../Util/GlobalStorage';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import AVSessionManager from '@ohos.multimedia.avsession';
import BrightnessUtils from '../../Util/BrightnessUtils';
import Constants, { ButtonIconName } from '../../Util/Constants';
import image from '@ohos.multimedia.image';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityUtil';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { SystemUIColorVm } from '@ohos/systemuicommon/src/main/ets/vm/SystemUIColorVm';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG = 'ControlButtonGroup_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const COMPONENT_ID_PAUSE = TAG + '_Image_pause';
const loopIcon: Resource[] = [
  $r(ButtonIconName.ORDER_PLAY_SYMBOL),
  $r(ButtonIconName.SINGLE_CYCLE_SYMBOL),
  $r(ButtonIconName.LIST_CYCLE_SYMBOL),
  $r(ButtonIconName.RANDOM_PLAY_SYMBOL),
];
const PLAY_BUTTON_OPERATE_MIN_INTERVAL: number = 200;

@Component
export default struct ControlButtonGroup {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled() && !ThreadUtil.isMainThread;
  @Prop skipIntervals: number;
  // properties
  @Prop sessionType: avSession.AVSessionType;
  @Prop iconSize: number;
  @Prop sceneType: string;
  @Prop @Watch('commandsUpdate') validCommands: Array<string>;
  @Prop isForceDark: boolean;
  @Prop isHasMedia: boolean; // media data state
  @Prop assetId: string | number;
  @Prop isClickSlider: boolean;
  @Link isClickRewind: boolean;
  @Link isClickFastForward: boolean;
  @Prop isFavor: boolean;
  @Prop @Watch('onLoopModeChanged') loopMode: number | undefined;
  @State curLoopMode: number = 0;
  @Prop isPlaying: boolean; // play state
  // class variable
  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance();
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  // command validation
  @State isCanPlayPrevious: boolean = false;
  @Link @Watch('updateShowPlayButton') isShowPlayButton: boolean;
  @State isCanPlayNext: boolean = false;
  @State isCanFavor: boolean = false;
  @State isCanLoopMode: boolean = false;
  @State isShowFastForward: boolean = false;
  @State isShowRewind: boolean = false;
  @State isCanPlay: boolean = true;
  @State isCanPause: boolean = true;
  fun: () => void = () => {
  };
  clearTimerAndProgressData: (isClearData:boolean) => void = () => {
  };
  private static readonly KEY_MEDIA_CARD_PRE = 'notification_media_card_';
  private static readonly KEY_PREVIOUS = 'previous';
  private static readonly KEY_PLAY_OR_PAUSE = 'play_or_pause';
  private static readonly KEY_NEXT = 'next';
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageProp('currColorMode') currColorMode: number = 0;
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;
  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);
  /**
   * size of buttons and icons
   */
  @State playIconSize: number = 30;
  @State bigIconSize: number = 24;
  @State smallIconSize: number = 22;
  @State bigButtonSize: number = 48;
  @State smallButtonSize: number = 40;
  /**
   * Is small external screen.
   */
  @Prop @Watch('smallFoldOuterScreen')isSmallFoldOuterScreen: boolean;

  // 是否做动效标记，数值改变触发动效
  @State fastForwardTriggerValue: number = 0;
  @State fastRewindTriggerValue: number = 0;
  @State isFavorButtonVisible: boolean = false;
  @State isPlayButtonVisible: boolean = false;
  @State isLoopModeButtonVisible: boolean = false;
  @StorageLink('showPlayLoading') showPlayLoading: boolean = false;
  private showPlayLoadingTimer: number | undefined = undefined;
  @StorageProp('canColdStart') canColdStart: boolean = false;
  private playButtonOperateTimeStamp: number = new Date().getTime();

  smallFoldOuterScreen() {
    log.showInfo(`smallFoldOuterScreen change: ${this.isSmallFoldOuterScreen}`);
    this.updateButtonSize();
  }

  async aboutToAppear() {
    this.commandsUpdate();
    if (this.loopMode) {
      this.onLoopModeChanged();
    }
    this.updateButtonSize();
  }

  aboutToDisappear() {
    this.clearLoadingTimer();
    this.showPlayLoading = false;
  }

  showLoading() {
    this.clearLoadingTimer();
    if (!this.canColdStart || this.sceneType !== 'expandMediaInfoCard') {
      return;
    }
    this.showPlayLoading = true;
    this.showPlayLoadingTimer = setTimeout(() => {
      this.showPlayLoading = false;
      this.clearLoadingTimer();
    }, Constants.LOADING_PLAY_DELAY);
  }

  clearLoadingTimer() {
    if (this.showPlayLoadingTimer) {
      clearTimeout(this.showPlayLoadingTimer);
      this.showPlayLoadingTimer = undefined;
    }
  }

  updateShowPlayButton() {
    log.showInfo(`update isShowPlayButton state update: ${this.isShowPlayButton}`);
    this.showPlayLoading = false;
    this.clearLoadingTimer();
  }

  @StorageLink('MediaImg') mediaImage: string | image.PixelMap = '';
  @StorageLink('MediaArtist') artist : string | boolean = this.getResourceString($r('app.string.no_media_title'));
  @StorageLink('ControlMediaTitle') @Watch('commandsUpdate') title : string | boolean = '';
  @Prop isDoubleExpand: boolean = false;
  @StorageLink('CurRemoteDevSelect') @Watch('commandsUpdate') curRemoteOutputDev : number = -1;
  @Prop @Watch('commandsUpdate') duration: number | undefined  = 0;
  public clickPlayButton: () => void = () => {};

  commandsUpdate() {
    log.showInfo(`valid commands update: ${this.validCommands}`);
    let validPlayOrPause: boolean = this.validCommands?.includes('play') && this.validCommands?.includes('pause');
    let canColdStart: boolean = this.sceneType === 'expandMediaInfoCard' ? this.canColdStart : true;
    if (this.isDoubleExpand) {
      if (this.validCommands === undefined || this.validCommands.length == 0) {
        this.isShowPlayButton = canColdStart;
        // 进入播控，音乐播放(play)按钮不置灰，其他按钮置灰；
        // 此时，点击播放，因为还未同意协议，且无任何历史数据，所以点击play无任何响应且play始终保持高亮；
        this.isCanPlayPrevious = false;
        this.isCanPlayNext = false;
        this.isCanFavor = false;
        this.isCanLoopMode = false;
        this.isShowFastForward = false;
        this.isShowRewind = false;
        return;
      }
      let canPlay: boolean = (!!this.title && !!this.artist || !!this.mediaImage) && this.isHasMedia;
      log.debug(`has validCommands: ${this.validCommands} , canplay = ${canPlay}`);
      this.isCanPlayPrevious = this.validCommands?.includes('playPrevious') && canPlay;
      this.isShowPlayButton = this.isHasMedia ? validPlayOrPause : canColdStart;
      this.isCanPlayNext = this.validCommands?.includes('playNext') && canPlay;
      this.isCanFavor = this.validCommands?.includes('toggleFavorite') && canPlay;
      this.isCanLoopMode = this.validCommands?.includes('setLoopMode') && canPlay;
      this.isShowFastForward = this.validCommands?.includes('fastForward') && canPlay && ((this.duration && this.duration > 0) || this.curRemoteOutputDev < 0);
      this.isShowRewind = this.validCommands?.includes('rewind') && canPlay && ((this.duration && this.duration > 0) || this.curRemoteOutputDev < 0);
    } else {
      this.isCanPlayPrevious = this.validCommands?.includes('playPrevious');
      this.isShowPlayButton = this.isHasMedia ? validPlayOrPause : canColdStart;
      this.isCanPlayNext = this.validCommands?.includes('playNext');
      this.isCanFavor = this.validCommands?.includes('toggleFavorite');
      this.isCanLoopMode = this.validCommands?.includes('setLoopMode');
      this.isShowFastForward = this.validCommands?.includes('fastForward') && ((this.duration && this.duration > 0) || this.curRemoteOutputDev < 0);
      this.isShowRewind = this.validCommands?.includes('rewind') && ((this.duration && this.duration > 0) || this.curRemoteOutputDev < 0);
    }
  }

  accessLoopMode(): string {
    switch (this.loopMode) {
      case AVSessionManager.LoopMode.LOOP_MODE_SINGLE:
        // 1-单曲
        return this.getResourceString($r('app.string.access_cyclic_mode_loop'))
      case AVSessionManager.LoopMode.LOOP_MODE_LIST:
        // 2-列表
        return this.getResourceString($r('app.string.access_cyclic_mode_list'))
      case AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE:
        // 3-随机
        return this.getResourceString($r('app.string.access_cyclic_mode_shuffle'))
      default:
      // 0-顺序
        return this.getResourceString($r('app.string.access_cyclic_mode_sequential'))
    }
  }

  getSkipIntervalsIcon(isFastForward: boolean): string {
    if (this.skipIntervals === 10) {
      return isFastForward ? ButtonIconName.FAST_FORWARD_10 : ButtonIconName.FAST_REWIND_10;
    } else if (this.skipIntervals === 30) {
      return isFastForward ? ButtonIconName.FAST_FORWARD_30 : ButtonIconName.FAST_REWIND_30;
    } else {
      return isFastForward ? ButtonIconName.FAST_FORWARD_15 : ButtonIconName.FAST_REWIND_15;
    }
  }

  onLoopModeChanged() {
    log.debug(`loopMode updated from parent cur loop mode is test: + ${this.curLoopMode}、${this.loopMode}`);
    this.curLoopMode = typeof this.loopMode === 'number' ? this.loopMode : 0;
  }

  setScenesType() {
    log.debug(`setScenesType + ${this.sceneType}`);
    globalStorage.setStringByKey('scenesType', this.sceneType);
    if (this.enableDc) {
      // 同步globalStorage至主线程
      this.dcController?.callGlobalStorage({name: 'scenesType', value: this.sceneType});
    }
  }

  getAodStyle() {
    log.debug('getAodStyle');
    let rgbaColor = [255, 255, 255, 60];
    const color: number | undefined = this.aodStyle?.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR);
    if (typeof color === 'number') {
      rgbaColor = [
        (color & 0x00FF0000) >> 16,
        (color & 0x0000FF00) >> 8,
        (color & 0x000000FF),
        ((color & 0xFF000000) >>> 24) / 255,
      ]
    }
    return rgbaColor;
  }

  updateButtonSize(): void {
    this.playIconSize = this.isSmallFoldOuterScreen ? 24 : 30;
    this.bigIconSize = this.isSmallFoldOuterScreen ? 20 : 24;
    this.smallIconSize = this.isSmallFoldOuterScreen ? 20 : 22;
    this.bigButtonSize = this.isSmallFoldOuterScreen ? 32 : 48;
    this.smallButtonSize = this.isSmallFoldOuterScreen ? 32 : 40;
  }

  isDarkMode() {
    // 隔离主线程调用
    let colorMode = ThreadUtil.isMainThread ? this.currColorMode : SystemUIColorVm.instance.colorMode;
    return colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  }

  getResourceString(data: Resource) {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return ResUtils.getInnerString(data);
    } else {
      return ResourceVm.instance.getString(data);
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      if (this.sessionType === 'audio') {
        if (this.isCanLoopMode) {
          Button({ stateEffect: true }) {
            SymbolGlyph(loopIcon[this.curLoopMode])
              .fontSize(`${this.bigIconSize}vp`)
              .draggable(false)
              .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
              .fontColor(this.aodStyle?.isAod ? [this.aodStyle?.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR)] :
                (this.isForceDark ? [$r('app.color.media_control_item_icon_primary')] : ['#000000']))
              .foregroundBrightness(this.aodStyle?.isAod ? undefined : this.sceneType === 'expandMediaInfoCard' ?
                this.colorModeViewData.foregroundPrimaryOption :
                BrightnessUtils.getInstance().getBrightnessOption(this.isSysColor, this.sceneType, this.isDarkMode()))
              .rotate({
                angle: this.loopMode === AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE ? this.isRTL() ? 180 : 0 : 0
              })
              .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isLoopModeButtonVisible)
          }
          .type(ButtonType.Circle)
          .size({ width: this.bigButtonSize, height: this.bigButtonSize })
          .backgroundColor(Color.Transparent)
          .opacity(1)
          .accessibilityLevel('yes')
          .accessibilityGroup(true)
          .accessibilityText(this.accessLoopMode())
          .id(Constants.BUTTON_GROUP_LOOP)
          .rotate({
            angle: this.loopMode === AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE ? this.isRTL() ? 180 : 0 : 0
          })
          .onClick(() => {
            if (this.isClickSlider) {
              log.showInfo('loopMode is invalid');
              return;
            }
            log.showInfo(`onclick loop mode: , ${this.curLoopMode}`);
            this.setScenesType();
            this.controller.callLoopMode(this.curLoopMode);
            setTimeout(() => {
              AccessibilityUtil.requestFocusAccessibility(Constants.BUTTON_GROUP_LOOP);
            }, 100)
          })
          .onVisibleAreaChange([0, 1], (isVisible: boolean, currentRatio: number) => {
            if (isVisible && currentRatio >= 1 && !this.isLoopModeButtonVisible) {
              this.isLoopModeButtonVisible = true;
            }
            if (!isVisible && currentRatio <= 0 && this.isLoopModeButtonVisible) {
              this.isLoopModeButtonVisible = false;
            }
          })
        } else {
          Blank()
            .width(this.bigButtonSize)
            .height(this.bigButtonSize)
            .visibility(Visibility.Hidden)
        }
      } else {
        Button({ stateEffect: this.isShowRewind }) {
          SymbolGlyph($r(this.getSkipIntervalsIcon(false)))
            .fontSize(`${this.bigIconSize}vp`)
            .fontColor(this.aodStyle?.isAod ? [this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR)] :
              (this.isShowRewind ? (!this.isForceDark ? [$r('app.color.ohos_id_color_primary')] :
                [$r('app.color.media_control_item_icon_primary')]) : (!this.isForceDark ?
                [$r('app.color.ohos_id_color_fourth')] : [$r('app.color.media_control_item_icon_disable')])))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.aodStyle?.isAod ? undefined : this.sceneType === 'expandMediaInfoCard' ?
              this.colorModeViewData.foregroundPrimaryOption :
              BrightnessUtils.getInstance().getBrightnessOption(this.isSysColor, this.sceneType, this.isDarkMode()))
            .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.DOWN), this.fastRewindTriggerValue)
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
        }
        .type(ButtonType.Circle)
        .backgroundColor(Color.Transparent)
        .size({ width: this.bigButtonSize, height: this.bigButtonSize })
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityDescription(this.isShowRewind ? '' : this.getResourceString($r('app.string.access_unavailable')))
        .accessibilityText(this.getResourceString($r('app.string.access_rewind')))
        .onClick(() => {
          if (!this.isShowRewind) {
            log.showInfo('rewind is invalid');
            return;
          }
          this.fastRewindTriggerValue++;
          this.setScenesType();
          this.controller.callRewindOrForward('rewind', this.skipIntervals);
          this.isClickRewind = true;
        })
      }

      Button({ stateEffect: this.isCanPlayPrevious }) {
        if (this.aodStyle?.isAod) {
          Image($r('app.media.ic_sing_previous'))
            .size({ width: 22, height: 22 })
            .scale({ x: 1.4, y: 1.5 })
            .draggable(false)
            .fillColor(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR) :
              (this.isCanPlayPrevious ?
                (!this.isForceDark ? $r('app.color.ohos_id_color_primary') : $r('app.color.media_control_item_icon_primary')) :
                (!this.isForceDark ? $r('app.color.ohos_id_color_fourth') : $r('app.color.media_control_item_icon_disable'))))
            .rotate({ angle: this.isRTL() ? 180 : 0 })
            .translate({x: -1})
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
        } else {
          AnimationIconLocal({
            active: this.isCanPlayPrevious,
            scaleValue: this.isSmallFoldOuterScreen ? 1.2 : 1.4,
            isControlCenter: this.isSmallFoldOuterScreen ? 'isSmallFoldOuterScreen' : 'item',
            sceneType: this.sceneType,
          })
            .size({ width: this.bigButtonSize, height: this.bigButtonSize })
            .rotate({ centerX: '50%', centerY: '50%', angle: 180 })
            .backgroundColor(Color.Transparent)
        }
      }
      .type(ButtonType.Circle)
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .accessibilityDescription(this.isCanPlayPrevious ? '' : this.getResourceString($r('app.string.access_unavailable')))
      .accessibilityText(this.getResourceString($r('app.string.access_previous')))
      .onClick(() => {
        if (!this.isCanPlayPrevious) {
          log.showInfo('play previous is invalid');
          return;
        }
        this.setScenesType();
        this.fun()
        this.clearTimerAndProgressData(false);
        setTimeout(() => {
          this.controller.callShowingPrevious();
        }, 166)
      })
      .size({ width: this.bigButtonSize, height: this.bigButtonSize })
      .backgroundColor(Color.Transparent)
      .key(ControlButtonGroup.KEY_MEDIA_CARD_PRE + ControlButtonGroup.KEY_PREVIOUS)

      Button({ stateEffect: this.isShowPlayButton }) {
        if (this.showPlayLoading && this.sceneType === 'expandMediaInfoCard') {
          LoadingProgress()
            .size({ width: this.playIconSize, height: this.playIconSize })
            .color($r('app.color.media_control_item_icon_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        } else {
          SymbolGlyph(this.isPlaying ? $r(ButtonIconName.PAUSE_SYMBOL) : $r(ButtonIconName.PLAY_SYMBOL))
            .fontSize(`${this.playIconSize}vp`)
            .fontColor(this.aodStyle?.isAod ? [this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR)] :
              (this.isShowPlayButton ? (!this.isForceDark ? [$r('app.color.ohos_id_color_primary')] :
                [$r('app.color.media_control_item_icon_primary')]) :
                (!this.isForceDark ? [$r('app.color.ohos_id_color_fourth')] :
                  [$r('app.color.media_control_item_icon_disable')])))
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isPlayButtonVisible)
            .draggable(false)
            .rotate({ angle: this.isRTL() ? 180 : 0 })
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.aodStyle?.isAod ? undefined : this.sceneType === 'expandMediaInfoCard' ?
              this.colorModeViewData.foregroundPrimaryOption :
              BrightnessUtils.getInstance().getBrightnessOption(this.isSysColor, this.sceneType, this.isDarkMode()))
            .id(COMPONENT_ID_PAUSE)
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
        }
      }
      .type(ButtonType.Circle)
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .accessibilityDescription(this.isShowPlayButton ? '' : this.getResourceString($r('app.string.access_unavailable')))
      .accessibilityText(this.isPlaying ? this.getResourceString($r('app.string.access_pause')) :
        this.getResourceString($r('app.string.access_play')))
      .onClick(() => {
        log.showInfo(`on play/pause click: ${this.isHasMedia}, ${this.isPlaying}`);
        this.setScenesType();
        if (!this.isShowPlayButton) {
          log.showInfo('playButton is invalid');
          return;
        }
        if (AppStorage.get('isNotificationFromDeviceChange')) {
          this.controller.startHistoryApp();
        } else if (!this.isHasMedia) {
          if (this.sceneType === 'expandMediaInfoCard') {
            globalStorage.setBooleanByKey('coldStartAnim', true);
            this.showLoading();
          }
          this.controller.startShowingDefaultApp();
        } else if (this.isPlaying) {
          this.controller.callShowingPause();
          this.clearTimerAndProgressData(false);
        } else {
          this.controller.callShowingPlay(false);
        }
        log.showInfo(`on play/pause click: clickPlayButton isPlaying: ${this.isPlaying}`);
        if (this.sceneType === 'expandMediaInfoCard') {
          let currentTimeStamp = new Date().getTime();
          if (currentTimeStamp > this.playButtonOperateTimeStamp &&
            currentTimeStamp - this.playButtonOperateTimeStamp > PLAY_BUTTON_OPERATE_MIN_INTERVAL) {
            if (!this.isPlaying) {
              log.showInfo(`change page`);
              this.clickPlayButton();
            }
            this.playButtonOperateTimeStamp = currentTimeStamp;
          }
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
      .size({ width: this.bigButtonSize, height: this.bigButtonSize })
      .backgroundColor(Color.Transparent)
      .key(ControlButtonGroup.KEY_MEDIA_CARD_PRE + ControlButtonGroup.KEY_PLAY_OR_PAUSE);

      Button({ stateEffect: this.isCanPlayNext }) {
        if (this.aodStyle?.isAod) {
          Image($r('app.media.ic_sing_next'))
            .size({ width: this.smallIconSize, height: this.smallIconSize})
            .scale({x: 1.5, y: 1.5})
            .draggable(false)
            .fillColor(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR) :
              (this.isCanPlayNext ?
                (!this.isForceDark ? $r('app.color.ohos_id_color_primary') : $r('app.color.media_control_item_icon_primary')) :
                (!this.isForceDark ? $r('app.color.ohos_id_color_fourth') : $r('app.color.media_control_item_icon_disable'))))
            .rotate({ angle: this.isRTL() ? 180 : 0 })
            .translate({x: 1})
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
        } else {
          AnimationIconLocal({
            active: this.isCanPlayNext,
            scaleValue: this.isSmallFoldOuterScreen ? 1.2 : 1.4,
            isControlCenter: this.isSmallFoldOuterScreen ? 'isSmallFoldOuterScreen' : 'item',
            sceneType: this.sceneType
          })
            .size({ width: this.bigButtonSize, height: this.bigButtonSize })
            .backgroundColor(Color.Transparent)
        }
      }
      .type(ButtonType.Circle)
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .accessibilityDescription(this.isCanPlayNext ? '' : this.getResourceString($r('app.string.access_unavailable')))
      .accessibilityText(this.getResourceString($r('app.string.access_next')))
      .onClick(() => {
        if (!this.isCanPlayNext) {
          log.showInfo('play next is invalid');
          return;
        }
        this.setScenesType();
        this.fun()
        this.clearTimerAndProgressData(false);
        setTimeout(() => {
          this.controller.callShowingNext();
        }, 166)
      })
      .size({ width: this.bigButtonSize, height: this.bigButtonSize })
      .backgroundColor(Color.Transparent)
      .key(ControlButtonGroup.KEY_MEDIA_CARD_PRE + ControlButtonGroup.KEY_NEXT);

      if (this.sessionType !== 'audio') {
        Button({ stateEffect: this.isShowFastForward }) {
          SymbolGlyph($r(this.getSkipIntervalsIcon(true)))
            .fontSize(`${this.bigIconSize}vp`)
            .fontColor(this.aodStyle?.isAod ? [this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR)] :
              (this.isShowFastForward ? (!this.isForceDark ? [$r('app.color.ohos_id_color_primary')] :
                [$r('app.color.media_control_item_icon_primary')]) : (!this.isForceDark ?
                [$r('app.color.ohos_id_color_fourth')] : [$r('app.color.media_control_item_icon_disable')])))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.aodStyle?.isAod ? undefined : this.sceneType === 'expandMediaInfoCard' ?
              this.colorModeViewData.foregroundPrimaryOption :
              BrightnessUtils.getInstance().getBrightnessOption(this.isSysColor, this.sceneType, this.isDarkMode()))
            .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.DOWN), this.fastForwardTriggerValue)
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
        }
        .type(ButtonType.Circle)
        .size({ width: this.bigButtonSize, height: this.bigButtonSize })
        .backgroundColor(Color.Transparent)
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityDescription(this.isShowFastForward ? '' : this.getResourceString($r('app.string.access_unavailable')))
        .accessibilityText(this.getResourceString($r('app.string.access_fast_forward')))
        .onClick(() => {
          if (!this.isShowFastForward) {
            log.showInfo('fastForward is invalid');
            return;
          }
          this.fastForwardTriggerValue++;
          this.setScenesType();
          this.controller.callRewindOrForward('fastForward', this.skipIntervals);
          this.isClickFastForward = true;
        })
      } else if (this.isCanFavor) {
        Button({ stateEffect: true }) {
          SymbolGlyph(this.isFavor ? $r(ButtonIconName.FAVOR_FILL_SYMBOL) : $r(ButtonIconName.FAVOR_SYMBOL))
            .fontSize(`${this.bigIconSize}vp`)
            .draggable(false)
            .fontColor(this.aodStyle?.isAod ? [this.aodStyle.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR)] :
              (!this.isForceDark ? [$r('app.color.ohos_id_color_primary')] :
                [$r('app.color.media_control_item_icon_primary')]))
            .foregroundBrightness(this.aodStyle?.isAod ? undefined : this.sceneType === 'expandMediaInfoCard' ?
              this.colorModeViewData.foregroundPrimaryOption :
              BrightnessUtils.getInstance().getBrightnessOption(this.isSysColor, this.sceneType, this.isDarkMode()))
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isFavorButtonVisible)
            .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup)// 增加UI缓存，防止丢帧
        }
        .type(ButtonType.Circle)
        .size({ width: this.bigButtonSize, height: this.bigButtonSize })
        .backgroundColor(Color.Transparent)
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityText(this.isFavor ? this.getResourceString($r('app.string.access_Favorited')) :
          this.getResourceString($r('app.string.access_favorites')))
        .id(Constants.BUTTON_GROUP_FAVOR)
        .onClick(() => {
          if (this.isHasMedia) {
            this.setScenesType();
            this.controller.callFavorites(this.assetId, this.isFavor || false);
          } else {
            log.error(TAG, 'error click favor');
          }
          setTimeout(() => {
            AccessibilityUtil.requestFocusAccessibility(Constants.BUTTON_GROUP_FAVOR);
          }, 100)
        })
        .onVisibleAreaChange([0, 1], (isVisible: boolean, currentRatio: number) => {
          if (isVisible && currentRatio >= 1 && !this.isFavorButtonVisible) {
            this.isFavorButtonVisible = true;
          }
          if (!isVisible && currentRatio <= 0 && this.isFavorButtonVisible) {
            this.isFavorButtonVisible = false;
          }
        })
      } else {
        Blank()
          .width(this.bigButtonSize)
          .height(this.bigButtonSize)
          .visibility(Visibility.Hidden)
      }
    }
    .accessibilityLevel('yes')
    .width('100%')
    .backgroundColor(Color.Transparent)
  }
}