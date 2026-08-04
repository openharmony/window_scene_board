/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import AVSessionManager from '@ohos.multimedia.avsession';
import BusinessError from '@ohos.base';
import Constants, { AVQueueInfo, ButtonIconName } from '../../Util/Constants';
import { globalStorage } from '../../Util/GlobalStorage';
import MediaInfoProvider from '../../Controller/MediaInfoProvider';
import { MediaInfoProviderDc } from '../../Controller/MediaInfoProviderDc';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ViewType, viewMgrPolicy } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import display from '@ohos.display';
import CommonUtils from '../../Util/CommonUtils';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import AnimationIconSimple from './AnimationIconSimple';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import PreferenceUtils from '../../Util/PreferencesUtils';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG: string = 'HistoricalListCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const SONG_LIST_MARGIN: number = 24;
const SONG_TITLE_MARGIN: number = 12;
const SONG_LIST_LENGTH: number = 3;
const SONG_LIST_LARGE_WIDTH: number = 72;

@Component
export struct HistoricalListCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private mediaInfoProvider: MediaInfoProvider | MediaInfoProviderDc = this.enableDc ?
    MediaInfoProviderDc.getInstance() : MediaInfoProvider.getInstance();
  private isPad: boolean = DeviceHelper.isPad();
  private isPhone: boolean = DeviceHelper.isPhone();
  @Link @Watch('landscapeChanged') isLandscape: boolean;
  @Link alInfoTmpList: Array<AVQueueInfo>;
  @Link albInfo: AVQueueInfo;
  @Link isClick: boolean;
  @Link isFoldDevice: boolean;
  @Prop isRecommendEightSupportTemp: boolean = false;
  @Prop whetherDisplay: boolean = true;
  private scroller: Scroller = new Scroller()

  private lastPlayState: number = 0;
  @StorageLink('MediaPlayState') @Watch('playStateUpdate')playState : number = 0;
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev: number = -1;

  isPlaying() {
    return CommonUtils.isPlaying(this.playState, this.lastPlayState, this.curRemoteOutputDev >= 0);
  }

  playStateUpdate() {
    if (this.playState != undefined) {
      if (this.playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        this.lastPlayState = this.playState;
      }
    }
  }
  @Link albumInfoListNew: Array<AVQueueInfo>;
  @Link isShowDev: boolean;
  @Link @Watch('canStartChanged') canStartAnimate: boolean;
  @Link indexTmp: number;
  @State bigImageOpacity: number = 1.0; //控制大图透明度
  @StorageLink('changeBigPicIconOpc') private bigPicIconOpacity:number = 1.0;
  @State bigImageTxtOpacity: number = 1.0; //控制大图专辑文字透明度
  @State bigImageScale: number = 1.0; //控制大图尺寸
  @Prop isShowMore: Visibility = Visibility.Hidden;
  @Link isShowPrefer: boolean;
  @Link hasStart: boolean;
  @Link hasFinished: boolean;
  @Link hasClickIndex: number;
  @Link titleResource: ResourceStr;
  @StorageLink('finishAnimate') private finishAnimate: boolean = true;
  @StorageLink('isDisplay') private isDisplay: boolean = false;
  @StorageLink('isStartPlaying') private isStartPlaying: boolean = false;
  @StorageLink('isTextOpacity') private isTextOpacity:boolean = false;
  @Link isFirstDataLength: boolean;
  @Link firstDataLength: number;
  @Link secondDataLength: number;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State preferHeight: number = 628;
  @State isSmallFoldDevice: boolean = DeviceHelper.isSingleDisplayPocketFoldDevice();
  @State titleMaxFontScale: number = Constants.SMALL_FOLD_DEVICE_TITLE_MAX_FONT_SCALE;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  /**
   * 控制是否开始 执行动画
   */
  canStartChanged() {
    log.showInfo(`meta data updateenter  startAnimate: ${this.canStartAnimate}`);
    if (this.isLandscapeLayout()) {
      log.showInfo(`meta data updateenter  startAnimate:isPhone & Land`);
      return;
    }
    if (this.canStartAnimate) {
      this.startAnimate(); //进入动画
    }
  }

  /**
   * 执行动画方法
   */
  startAnimate() {
    log.showInfo(`startAnimate,start`);
    this.hasStart = true;
    this.hasFinished = false;
    this.isTextOpacity = true;
    AppStorage.setOrCreate('isTextOpacity', this.isTextOpacity);
    AppStorage.setOrCreate('clickItemAnimationStart', true);

    setTimeout(() => {
      AppStorage.setOrCreate('isRefreshData', true);
      this.hasStart = false;
      this.hasFinished = true;
      this.canStartAnimate = false;
      this.indexTmp = -1;
      AppStorage.setOrCreate('clickItemAnimationStart', false);
      this.isClick = false;
    }, 300)
    // 冷启动临界点文字不做淡出动画（临界点： 4->3,3->2,2->1,1->0），要在第一次冷启动之后和动画完成之前赋值
    // 既保证冷启动没有淡出，同时保证之后做文字淡隐淡出动画
    this.secondDataLength = this.alInfoTmpList.length;
  }

  // 检查是否是折叠屏
  isFoldable(): boolean {
    return this.isFoldDevice;
  }

  /**
   * 获取可折叠设备的当前折叠状态
   * @returns
   */
  getFoldStatus(): boolean {
    try {
      const foldStatus = display.getFoldStatus();
      return foldStatus == 2; // 2 == FOLD_STATUS_FOLDED
    } catch (error) {
      return false;
    }
  }

  async aboutToAppear() {
    this.titleMaxFontScale = this.isSmallFoldDevice ? Constants.SMALL_FOLD_DEVICE_TITLE_MAX_FONT_SCALE :
      Constants.TITLE_MAX_FONT_SCALE;
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear.');
    let viewController = viewMgrPolicy.getViewController(ViewType.DROPDOWN);
    viewController?.setZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
  }

  landscapeChanged() {
    log.showInfo(`his landscapeChanged` + this.isLandscape);
  }

  isLandscapeLayout() {
    // 折叠状态的折叠屏
    if (this.isFoldable()) {
      return this.getFoldStatus() && this.isLandscape;
    } else if (this.isPhone) {
      return this.isLandscape;
    }
    return false;
  }

  /**
   * 是否是纵向列表,歌单数量<3||手机横屏
   * @returns boolean
   */
  private isRowList(): boolean {
    // 歌单列表纵向表示
    return this.alInfoTmpList.length < SONG_LIST_LENGTH || this.isLandscapeLayout();
  }

  /**
   * 获取卡片列表的间距
   * @returns number
   */
  private getColumnListSpace(): number {
    if (this.isRowList()) {
      return SONG_TITLE_MARGIN;
    }
    let space = 0;
    if (this.alInfoTmpList.length === SONG_LIST_LENGTH) {
      // 3个卡片的间距=（总宽度-2*左右边距-卡片的宽度*3）/2
      space = (Constants.PANEL_PORTRAIT_WIDTH - Constants.CARD_EDGE_PADDING * 2 - SONG_LIST_LARGE_WIDTH * 3) / 2
    } else if (this.alInfoTmpList.length > SONG_LIST_LENGTH) {
      // 3.5个卡片的间距=（总宽度-左边距-卡片的宽度*3.5）/3
      space = (Constants.PANEL_PORTRAIT_WIDTH - Constants.CARD_EDGE_PADDING - SONG_LIST_LARGE_WIDTH * 3.5) / 3
    }
    return space;
  }

  replayAlInfo(albInfo: AVQueueInfo): void {
    this.mediaInfoProvider?.replayAlbum(albInfo, this.albInfo);
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  /**
   * 偏好设置菜单
   */
  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: $r('app.string.preference_setting') })
        .width('100%')
        .id('id_preference_setting')
        .onClick(() => {
          log.showInfo(`onClick isShowPrefer`);
          this.isShowPrefer = true;
        })
    }
    // .fontSize(FontSizeScaleUtil.getLimitFontSize(this.getFontSizeScale(), FontSizeScaleEnum.XS_LARGE,
      // $r('sys.float.Body_L')))
    .width(224)
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text(this.titleResource)
            .fontColor($r('app.color.media_control_text_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(this.titleMaxFontScale)
            .fontWeight('sys.string.ohos_id_text_font_family_medium')
            .height(48)
            .width('70%')
            .maxLines(1)
            .wordBreak(WordBreak.HYPHENATION)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .align(Alignment.Center)
            .key('historical_recently_play')
            .margin({
              left: SONG_LIST_MARGIN,
              right: SONG_LIST_MARGIN
            })

          Button() {
            SymbolGlyph($r(ButtonIconName.COLLECT_MORE_SYMBOL))
              .borderRadius(8)
              .fontSize(`${SONG_LIST_MARGIN}vp`)
              .responseRegion({
                x: 0,
                y: 0,
                width: '133%',
                height: '133%'
              })
              .id('collectMore')
              .visibility(this.isShowMore)
              .fontColor([$r('app.color.media_control_icon_primary')])
              .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          }
          .margin({
            left: this.isRTL() ? SONG_LIST_MARGIN : 0,
            right: this.isRTL() ? 0 : SONG_LIST_MARGIN,
          })
          .bindMenu(this.MenuBuilder(), { placement: Placement.Top })
          // .bindSheet($$this.isShowPrefer,
          //   PreferenceSettingViewBuilder({ isShow: this.isShowPrefer, isPad: this.isPad }), {
          //   detents: [this.preferHeight],
          //   height: this.preferHeight,
          //   dragBar: false,
          //   preferType: SheetType.CENTER,
          //   backgroundColor: Color.Transparent,
          //   blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
          //   showClose: false,
          // })
          // .backgroundColor(Color.Transparent)
          // .accessibilityLevel('yes')
          // .accessibilityGroup(true)
          // .accessibilityText(ResUtils.getInnerString($r('app.string.access_More')))
        }
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)


        Stack({
          alignContent: this.isLandscapeLayout() && this.alInfoTmpList.length >= 4 ? Alignment.End : Alignment.Start
        }) {
          List({
            space: this.getColumnListSpace(),
            scroller: this.scroller }) {
            ForEach(this.albumInfoListNew, (alInfo: AVQueueInfo, index) => {
              ListItem() {
                Flex({
                  direction: this.isRowList() ? FlexDirection.Row :
                  FlexDirection.Column,
                  alignItems: ItemAlign.Center
                }) {
                  Stack({ alignContent: Alignment.BottomEnd }) {
                    Image(alInfo.avQueueImage)
                      .alt($r('app.media.ic_nomusic_img'))
                      .fillColor($r('sys.color.ohos_id_color_fourth_dark'))
                      .backgroundColor($r('sys.color.ohos_id_color_button_normal_dark'))
                      .width('100%')
                      .height('100%')
                      .objectFit(ImageFit.Cover)
                      .borderRadius($r('sys.float.corner_radius_level4'))
                      .clip(Constants.SECOND_PANEL_CLIP)
                      .visibility(this.isShowDev ? Visibility.None : Visibility.Visible)
                      .draggable(false)
                      .zIndex(0)

                    Image(alInfo.appIconImage)
                      .width('16vp')
                      .height('16vp')
                      .borderRadius(globalStorage.getBooleanByKey('isTabletDevice')
                        ? Constants.TABLET_WINDOW_DEFAULT_RADIUS : $r('sys.float.ohos_id_corner_radius_default_xs'))
                      .clip(Constants.SECOND_PANEL_CLIP)
                      .interpolation(ImageInterpolation.Medium)
                      .autoResize(false)
                      .draggable(false)
                      .border({ width: 0.5, color: '#D1D1D6' })
                      .zIndex(2)

                    if (this.hasClickIndex === index) {
                      Column() {
                      }
                      .zIndex(1)
                      .backgroundColor(Color.Black)
                      .opacity(0.5)
                      .width('100%')
                      .height('100%')
                      .clip(Constants.SECOND_PANEL_CLIP)
                      .borderRadius($r('sys.float.corner_radius_level4'))
                      .transition(
                        TransitionEffect.asymmetric(
                          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 }),
                          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 })
                        )
                      )

                      Column() {
                        AnimationIconSimple({
                          name: `clickAlbum_${index}`,
                          src: 'clickAlbum.json',
                          active: true,
                          color: [255, 255, 255],
                          isPlaying: this.isPlaying()
                        })
                      }
                      .zIndex(3)
                      .width('100%')
                      .height('100%')
                      .clip(Constants.SECOND_PANEL_CLIP)
                      .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
                      .alignItems(HorizontalAlign.Center)
                      .padding({ top: this.isRowList() ? 7 : 19 })
                      .transition(
                        TransitionEffect.asymmetric(
                          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 }),
                          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 })
                        )
                      )
                    }
                  }
                  .width(this.isRowList() ? 48 : SONG_LIST_LARGE_WIDTH)
                  .height(this.isRowList() ? 48 : SONG_LIST_LARGE_WIDTH)
                  .clip(Constants.SECOND_PANEL_CLIP)
                  .flexGrow(0)
                  .flexShrink(0)
                  .flexBasis('auto')
                  .key(index.toString())
                  .clickEffect({level:ClickEffectLevel.LIGHT})
                  Flex({
                    justifyContent: this.isRowList() ? FlexAlign.Start : FlexAlign.Start,
                    alignItems: this.isRowList() ? ItemAlign.End : ItemAlign.Center
                  }) {
                    Text(alInfo.avQueueName)
                      .fontSize(this.isRowList() ?
                      $r('sys.float.ohos_id_text_size_body1') : $r('sys.float.ohos_id_text_size_body3'))
                      .maxFontScale(1.15)
                      .fontColor($r('app.color.media_control_text_primary'))
                      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
                      .fontWeight('sys.string.ohos_id_text_font_family_regular')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .clip(true)
                      .heightAdaptivePolicy(TextHeightAdaptivePolicy.LAYOUT_CONSTRAINT_FIRST)
                  }
                  .width('100%')
                  .margin({
                    left: !this.isRowList() ? 0 : this.isRTL() ? 0 : SONG_TITLE_MARGIN,
                    right: !this.isRowList() ? 0 : this.isRTL() ? SONG_TITLE_MARGIN : 0,
                    top: this.isRowList() ? 0 : 4
                  })
                }
                .width(this.isRowList() ? '100%' : SONG_LIST_LARGE_WIDTH)
              }
              .id('mediaItem' + index)
              .enabled(!this.isClick)
              .clip(false)
              .onVisibleAreaChange([0, 1.0], (isVisible: boolean, currentRatio: number) => {
                log.showInfo(`onVisibleAreaChange,index:${index},isVisible:${isVisible},currentRatio:${currentRatio}`);
              })
              .onClick((event) => {
                log.showInfo(`has clicked entry`);
                if (!this.whetherDisplay) {
                  return;
                }
                if (this.hasClickIndex === index && this.isPlaying()) {
                  log.showInfo(`current album already playing`);
                  return
                }
                if (this.hasClickIndex === index && !this.isPlaying()) {
                  this.replayAlInfo(alInfo);
                  log.showInfo(`replayAlInfo,`);
                  return
                }
                if (!this.isLandscapeLayout()) {
                  AppStorage.setOrCreate('clickAlbum', true);
                }
                this.isFirstDataLength = false;
                this.finishAnimate = false;
                this.isDisplay = false;
                AppStorage.setOrCreate('isDisplay', this.isDisplay);
                this.isStartPlaying = false;
                AppStorage.setOrCreate('isStartPlaying', this.isStartPlaying);
                AppStorage.setOrCreate('finishAnimate', this.finishAnimate);
                if (!this.hasStart || this.hasFinished) { //动画未开始 或已结束才能计算
                  this.hasClickIndex = index;
                  this.indexTmp = index;
                  this.albInfo = alInfo;
                }
              })
              .key('historical_list_item' + index)
              .height(this.isRowList() ? 48 : '')
              .id('historical_list_item' + index)
            })
          }
          .onAppear(() => {
            log.showInfo(`onAppear,report to HA`);
          })
          .scrollSnapAlign(ScrollSnapAlign.START)
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.None)
          .listDirection(this.isRowList() ? Axis.Vertical : Axis.Horizontal)
          .contentStartOffset(!this.isRowList() ? SONG_LIST_MARGIN : 0)
          .contentEndOffset(!this.isRowList() ? SONG_LIST_MARGIN : 0)
          .edgeEffect(!this.isRowList() ? EdgeEffect.Spring : EdgeEffect.None)
          .chainAnimation(!this.isRowList())
          .margin({ left: this.isRowList() ? 24 : 0, right: this.isRowList() ? 24 : 0 })
          .key('historical_list')


          ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto }) {
            Text()
              .width(4)
              .height(80)
              .borderRadius($r('sys.float.ohos_id_corner_radius_progress_bar'))
              .opacity($r('sys.float.ohos_id_alpha_content_tertiary'))
              .backgroundColor($r('app.color.media_control_scroll_bar'))
          }
          .margin({ bottom: SONG_TITLE_MARGIN })
          .padding({ left: this.isRTL() && this.isLandscapeLayout() && this.alInfoTmpList.length >
            SONG_LIST_LENGTH ? 4 : 0 })
          .width(8)
          .visibility(this.isFoldable() && !this.getFoldStatus ?
            this.alInfoTmpList.length >= 4 ? Visibility.Visible : Visibility.None :
            (this.isLandscapeLayout() && this.alInfoTmpList.length >= 4) ? Visibility.Visible : Visibility.None)
          .key('historical_scroll_bar')

        }
        .height('')

      }
      .height(this.isRowList() ? '' : 180)
      .padding({
        bottom: (this.isLandscapeLayout() && this.alInfoTmpList.length >= 4) ? 48 : 14,
      })
    }
  }
}