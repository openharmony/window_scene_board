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
import Constants, { AVQueueInfo, FoldHeight, ButtonIconName } from '../../Util/Constants';
import { DcMediaController } from '../../Controller/DcMediaController';
import MediaInfoProvider from '../../Controller/MediaInfoProvider';
import { MediaInfoProviderDc } from '../../Controller/MediaInfoProviderDc';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import display from '@ohos.display';
import Curves from '@ohos.curves';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import AnimationIconSimple from './AnimationIconSimple';
import CommonUtils from '../../Util/CommonUtils';
import AVSessionManager from '@ohos.multimedia.avsession';
import { CardMediaController, ShowingMesTS } from '../../Controller/CardMediaController';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ViewType, viewMgrPolicy } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const SONG_LIST_MARGIN: number = 24;
const TAG: string = 'ExpandHistoryCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct ExpandHistoryCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private mediaInfoProvider: MediaInfoProvider | MediaInfoProviderDc = this.enableDc ?
    MediaInfoProviderDc.getInstance() : MediaInfoProvider.getInstance();
  @Link isAlbumListReady: boolean;
  private cardHeight: number = Constants.HIS_CARD_HEIGHT; //历史歌单卡高度
  @State hasClickIndex: number = -1;
  @StorageLink('CurAvQueueId') @Watch('albumIDChange') albumID: string = '';

  //媒体卡高度差 + 歌单卡和媒体卡之间的间距15 + 历史歌单卡的高度 = 位移高度
  private translateY: number = this.cardHeight + 15 + Constants.PANEL_EXPAND_HEIGHT -
  Constants.PANEL_EXPAND_HEIGHT_SMALL;

  private isPad: boolean = DeviceHelper.isPad();
  @StorageLink('AlbumInfoList') @Watch('listDataChanged') albumInfoList: Array<AVQueueInfo> = [];
  private isFoldDevice: boolean = true;
  private disNumber: number = 3;
  private scroller: Scroller = new Scroller();
  @Link @Watch('showDevChange') isShowDev: boolean;
  @State positionX: number = 0;
  @State positionXText: number = 0;
  @State positionY: number = 0;
  @State appIconImage: number | string = 16;
  @State isShowMore: Visibility = Visibility.Hidden;
  @State moreIconMargin: number = 0;
  @Link isShowPrefer: boolean;
  @StorageLink('titleResource') titleResource: Resource = $r('app.string.RecentlyPlay');
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State preferHeight: number = 628;
  private historicalItemWidth: number = 70; //大于等于dis number的时候，每一个歌单item的宽度，
  @StorageLink('isStartAVPlaybackSuccess') @Watch('isStartSuccess') isStartAVPlaybackSuccess: boolean = false;
  @StorageLink('isVideo') isVideo: boolean = false;
  private lastPlayState: number = 0;
  @State playState : number | undefined = 0;
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev: number = -1;
  private avControllerCallback: LocalEventCallback | undefined = undefined;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  private showDevChangeEffect: TransitionEffect =
    TransitionEffect.translate({ y: -this.translateY})
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.OPACITY.animation({ duration: 150, curve: Curve.Sharp}))
      .combine(TransitionEffect.rotate({ x: 1, angle: 60 }).animation({ duration: 250, curve:
      Curve.Friction}))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 }).animation({
        curve: Curves.interpolatingSpring(0, 1, 228, 25) }))

  private effect: TransitionEffect =
    TransitionEffect.translate({ y: -this.cardHeight}) //数值越大，消失的时候，往上飞的越高
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.OPACITY.animation({ duration: 250, curve: Curve.Sharp}))
      .combine(TransitionEffect.rotate({ x: 1, angle: 60 }).animation({ duration: 250, curve:
      Curve.Friction}))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 }).animation({
        curve: Curves.interpolatingSpring(0, 1, 228, 25) }))

  public async listDataChanged() {
    this.albumIDChange();
  }

  albumIDChange() {
    if (this.albumID && !this.isVideo) {
      this.hasClickIndex = this.albumInfoList.findIndex((v => {
        return v.avQueueId == this.albumID;
      }));
    }
  }

  /**
   * 设备列表展示和最近播放展示切换回调
   */
  public showDevChange() {
    log.showInfo(`showDevChange,:${this.isShowDev}`);
    if (!this.isShowDev) {
      this.listDataChanged();
    }
  }

  isSmallAvQueueName(): boolean {
    return this.albumInfoList.length < this.disNumber ? false : true;
  }

  getFoldStyle() {
    let foldStyle: FoldHeight = {};
    foldStyle.direction = FlexDirection.Column;
    foldStyle.listDirection = Axis.Horizontal;
    foldStyle.historicalWidth = '';
    foldStyle.historicalHeight = '';
    foldStyle.historicalFontSize = '';
    foldStyle.historicalMaxLines = 2;
    foldStyle.historicalMargin = {};
    foldStyle.direction = (!this.isSmallAvQueueName()) ? FlexDirection.Row : FlexDirection.Column;
    foldStyle.listDirection = (!this.isSmallAvQueueName()) ? Axis.Vertical : Axis.Horizontal;
    if (!this.isSmallAvQueueName()) {
      foldStyle.historicalWidth = 48;
      foldStyle.historicalHeight = 48;
    } else {
      foldStyle.historicalWidth = this.historicalItemWidth;
      foldStyle.historicalHeight = this.historicalItemWidth;
    }
    foldStyle.height = (!this.isSmallAvQueueName()) ? '' : (this.historicalItemWidth + 30 + 4);
    foldStyle.historicalFontSize = (!this.isSmallAvQueueName()) ?
    $r('sys.float.ohos_id_text_size_body1') : 11.61;
    foldStyle.historicalMargin = {
      top : !this.isSmallAvQueueName() ? '' : 4,
      left: !this.isSmallAvQueueName() ?
        (this.isRTL() ? 48 : 12) : 0,
      right: !this.isSmallAvQueueName() ?
        (this.isRTL() ? 12 : 48) : 0
    };

    foldStyle.historicalColumnHeight = (!this.isSmallAvQueueName()) ? '' : this.cardHeight;
    if (this.albumInfoList.length === this.disNumber) {
      foldStyle.historicalSpace = (Constants.PANEL_EXPAND_WIDTH - this.historicalItemWidth * this.disNumber -
        Constants.CARD_EDGE_PADDING * 2) / 2; //子组件主轴方向的间隔。（卡片宽度-两边边距各24-三个图）/2
    } else {
      foldStyle.historicalSpace = 11.66; //子组件主轴方向的间隔。
    }

    if (!this.isSmallAvQueueName()) {
      foldStyle.width = '100%';
    } else {
      foldStyle.width = this.historicalItemWidth;
    }
    return foldStyle;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear.');
    log.showInfo('ExpandHistoryCardController.albumInfoListLink.length:' + this.albumInfoList.length);
    this.hasClickIndex = -1; //每次重新打开更新点击色块
    this.setMediaDataListener();
    this.listDataChanged();
    this.playState = AppStorage.get('MediaPlayState');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear.');
    this.unsetMediaDataListener();
  }

  unsetMediaDataListener() {
    if (!this.avControllerCallback) {
      return;
    }
    CardMediaController.off('mediaUpdate', this.avControllerCallback, TAG);
  }

  mediaDataUpdate(mediaInfo: ShowingMesTS) {
    if (mediaInfo.playState !== undefined) {
      log.debug(`parse media data: playState = ${mediaInfo.playState}`);
      this.playState = mediaInfo.playState;
      const playState: number = mediaInfo.playState as number;
      if (playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        this.lastPlayState = playState;
      }
    }
  }

  setMediaDataListener() {
    this.avControllerCallback = new LocalEventCallback((mediaInfo: ShowingMesTS) => {
      log.debug(` media data update: ${JSON.stringify(mediaInfo)} `);
      setTimeout(() => {
        this.mediaDataUpdate(mediaInfo);
      }, 0);
    });
    CardMediaController.on('mediaUpdate', this.avControllerCallback, TAG);
  }

  isPlaying() {
    let playState = (this.playState === undefined) ? 0 : this.playState;
    let isPlaying = CommonUtils.isPlaying(playState, this.lastPlayState, this.curRemoteOutputDev >= 0);
    if (isPlaying && this.hasClickIndex == -1) {
      this.albumIDChange(); //由小边边到播放态历史歌单完全展开，更新在播歌单动效
    }
    return isPlaying;
  }

  isStartSuccess() {
    if (this.isStartAVPlaybackSuccess) {
      return;
    } else {
      //如果切歌失败，跳动符号回到正在播放的那一首
      this.albumIDChange();
    }
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

  build() {
    if (this.isAlbumListReady && this.albumInfoList.length > 0) {
      Column() {
        Column() {
          Row() {
            Text(this.titleResource)
              .fontColor($r('app.color.media_control_text_primary'))
              .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
              .fontSize(14)
              .maxFontScale(1.2)
              .fontWeight('sys.string.ohos_id_text_font_family_medium')
              .height(19)
              .width('70%')
              .maxLines(1)
              .wordBreak(WordBreak.HYPHENATION)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .align(Alignment.Center)
              .key('historical_recently_play')
              .margin({
                top: 12,
                bottom: 13,
                left: 0,
                right: this.isRTL() ? 24 : 0
              })

            Button() {
              SymbolGlyph($r(ButtonIconName.COLLECT_MORE_SYMBOL))
                .fontSize(`${SONG_LIST_MARGIN}vp`)
                .borderRadius(0)
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
              left: 0,
              right: 24
            })
            .backgroundColor(Color.Transparent)
            .accessibilityLevel('yes')
            .accessibilityGroup(true)
            .accessibilityText(ResUtils.getInnerString($r('app.string.access_More')))
          }
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Stack({
            alignContent: (this.albumInfoList.length > this.disNumber) ? Alignment.End : Alignment.Start
          }) {
            List({ space: this.getFoldStyle().historicalSpace, scroller: this.scroller }) {
              ForEach(this.albumInfoList, (alInfo: AVQueueInfo, index) => {
                ListItem() {
                  Flex({
                    direction: this.getFoldStyle().direction,
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
                        .draggable(false)
                        .zIndex(0)

                      Image(alInfo.appIconImage)
                        .width('17vp')
                        .height('17vp')
                        .borderRadius('4.22px')
                        .clip(Constants.SECOND_PANEL_CLIP)
                        .interpolation(ImageInterpolation.Medium)
                        .autoResize(false)
                        .draggable(false)
                        .zIndex(2)

                      if (this.hasClickIndex === index) {
                        Column() { }
                        .zIndex(1)
                        .backgroundColor(Color.Black)
                        .width(this.getFoldStyle().historicalWidth)
                        .height(this.getFoldStyle().historicalHeight)
                        .clip(Constants.SECOND_PANEL_CLIP)
                        .borderRadius($r('sys.float.corner_radius_level4'))
                        .opacity(0.5)
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
                        .justifyContent(FlexAlign.Center)
                        .align(Alignment.Center)
                        .zIndex(3)
                        .width(this.getFoldStyle().historicalWidth)
                        .height(this.getFoldStyle().historicalHeight)
                        .clip(Constants.SECOND_PANEL_CLIP)
                        .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
                        .transition(
                          TransitionEffect.asymmetric(
                            TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 }),
                            TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 })
                          )
                        )
                      }
                    }
                    .width(this.getFoldStyle().historicalWidth)
                    .height(this.getFoldStyle().historicalHeight)
                    .clip(Constants.IMAGE_ANIMATOR_REVERSE)
                    .flexGrow(0)
                    .flexShrink(0)
                    .flexBasis('auto')
                    .key(index.toString())
                    .clickEffect({level:ClickEffectLevel.LIGHT})

                    Flex({
                      justifyContent: this.isSmallAvQueueName() ? FlexAlign.Center : FlexAlign.Start,
                      alignItems: this.isSmallAvQueueName() ? ItemAlign.End : ItemAlign.Center
                    }) {
                      Text(alInfo.avQueueName)
                        .fontSize(this.getFoldStyle().historicalFontSize)
                        .maxFontScale(1)
                        .fontColor($r('app.color.media_control_text_primary'))
                        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
                        .fontWeight('sys.string.ohos_id_text_font_family_regular')
                        .maxLines(this.getFoldStyle().historicalMaxLines)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .width(this.getFoldStyle().width)
                        .lineHeight((!this.isSmallAvQueueName()) ? 24 : 15)
                        .textAlign(this.isRTL() ? TextAlign.End : TextAlign.Start)
                    }
                    .height(this.isSmallAvQueueName() ? '' : 48)
                    .margin(this.getFoldStyle().historicalMargin)
                  }
                  .width(this.getFoldStyle().width)
                }
                .id('mediaItem' + index)
                .clip(false)
                .onVisibleAreaChange([0, 1.0], (isVisible: boolean, currentRatio: number) => {
                  log.showInfo(`onVisibleAreaChange,index:${index},isVisible:${isVisible},currentRatio:${currentRatio}`);
                })
                .onClick((event) => {
                  this.hasClickIndex = index;
                  if (alInfo?.avQueueId) {
                    this.albumID = alInfo.avQueueId;
                  }
                  this.mediaInfoProvider?.startExpandAlbum(alInfo, this.albumInfoList);
                  AppStorage.setOrCreate('clickAlbum', true);
                })
                .key('historical_list_item' + index)
                .height(this.getFoldStyle().height)
              })
            }
            .onAppear(() => {
              log.showInfo(`onAppear,report to HA`);
            })
            .scrollSnapAlign(ScrollSnapAlign.START)
            .scrollBar(BarState.Off)
            .edgeEffect(this.isSmallAvQueueName() ? EdgeEffect.Spring : EdgeEffect.None)
            .listDirection(this.getFoldStyle().listDirection)
            .contentStartOffset(0)
            .contentEndOffset(this.isSmallAvQueueName() ? 24 : 0)
            .chainAnimation(this.isSmallAvQueueName())
            .borderRadius({
              bottomRight: 0,
              bottomLeft: 0
            })
            .key('historical_list')

            ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.On }) {
              Text()
                .width(4)
                .height(80)
                .borderRadius($r('sys.float.ohos_id_corner_radius_progress_bar'))
                .opacity($r('sys.float.ohos_id_alpha_content_tertiary'))
            }
            .margin({ bottom: 4})
            .width(8)
            .visibility(Visibility.None)
            .clip(true)
            .key('historical_scroll_bar')
          }
          .height(this.getFoldStyle().height)
          .width('100%')
          .margin({
            left: this.isRTL() ? 0 : '',
            right: this.isRTL() ? 48 : ''
          })
        }
        .padding({
          bottom: (this.albumInfoList.length >= this.disNumber) ? 48 : 14,
          left: 24,
          right: 0
        })
      }
      .transition(this.isShowDev ? this.showDevChangeEffect : this.effect)
      .height(this.getFoldStyle().historicalColumnHeight)
      .backgroundColor($r('app.color.media_control_card_bgc'))
      .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
      .saturate(1)
      .shadow({ radius : 0})
      .backdropBlur(undefined)
      .borderRadius(Constants.MEDIA_CARD_BORDER_RADIUS)
      .border({
        width: 0,
        color: '#00000000',
      })
      .width('100%')
      .constraintSize({ maxHeight: this.cardHeight })
      .margin({top: 15 })
      .key('historical_expand_card')
      .clip(true)
      .onTouch((event?: TouchEvent) => {
        event?.stopPropagation();
      })
    }
  }
}