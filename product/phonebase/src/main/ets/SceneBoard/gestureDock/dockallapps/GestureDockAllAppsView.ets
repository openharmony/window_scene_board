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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils, SCBScreenProperty } from '@ohos/windowscene';
import { viewMgrPolicy, ViewType, } from '@ohos/frameworkwrapper';
import { GestureDockConstants } from '../common/GestureDockConstants';
import { GestureDockItemInfo } from '../dockbar/model/GestureDockItemInfo';
import { AllAppsConstants } from './model/AllAppsConstants';
import { HiSysDockAddAppSourceData } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import { SymbolGlyphModifier } from '@ohos.arkui.modifier';
import { LengthMetrics } from '@kit.ArkUI';
import GestureDockAllAppsViewDataMgr from './viewmodel/viewdata/GestureDockAllAppsViewDataMgr';
import { AllAppsParam } from './viewmodel/viewdata/GestureDockAllAppsParam';
import { GestureDockAllAppsItemView } from '../dockappitem/GestureDockAllAppsItemView';
import GestureDockAllAppsViewEventMgr from './viewmodel/viewevent/GestureDockAllAppsViewEventMgr';
import { GestureDockAllAppsViewModel } from './viewmodel/GestureDockAllAppsViewModel';
import { GestureDockViewModel } from '../dock/viewmodel/GestureDockViewModel';
import { KeyCode } from '@kit.InputKit';
import { CommonConstants } from '@ohos/launchercommon';

const TAG = 'GestureDockAllAppsView';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const BLENDMODE_SRC_OVER: number = 1000;
const BLENDMODE_DESTINATION_IN: number = 6;
// 深色浅色模式均使用同一个颜色
const COLOR_TEXT_SECONDARY: string = '#99FFFFFF';
const COLOR_TEXT_PRIMARY: string = '#E6FFFFFF';
const MARGIN_START: number = 10;

@Extend(Image)
function iconStyle() {
  .width(16)
  .height(16)
  .fillColor($r('app.color.color_text_secondary'))
  .margin({
    start: LengthMetrics.vp(10)
  })
}

/**
 * allApps宫格视图种类
 */
export enum GestureDockAllAppsIcon {
  SEARCH_RESULT = 10,
  RECENT_APPS = 11,
  FLOAT_APPS = 12,
}

@Component
export struct GestureDockAllAppsView {
  private viewDataMgr = new GestureDockAllAppsViewDataMgr();
  private viewEventMgr = new GestureDockAllAppsViewEventMgr(this.viewDataMgr);

  @State allAppsParam: AllAppsParam = this.viewDataMgr.allAppsParam;
  @Link @Watch('initStyleConfig') screenProperty: SCBScreenProperty;
  @Provide isUseRenderGroup: boolean = false;

  /**
   * aboutToAppear
   */
  async aboutToAppear(): Promise<void> {
    log.showInfo(`[${TAG}] about to appear`);
    GestureDockAllAppsViewModel.getInstance().initViewModel(this.viewEventMgr);
    this.viewEventMgr.aboutToAppear(this.screenProperty);
    this.isUseRenderGroup = true;
  }

  /**
   * aboutToDisappear
   */
  aboutToDisappear(): void {
    log.showInfo(`[${TAG}] about to disappear`);
    this.isUseRenderGroup = false;
    this.viewEventMgr.aboutToDisappear();
    GestureDockAllAppsViewModel.getInstance().clearViewModel();
  }

  private initStyleConfig(): void {
    this.viewEventMgr.initStyleConfig(this.screenProperty);
  }

  build() {
    Column() {
      Stack() {
        Column() {
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            // 标题栏
            this.titleBarBuilder();
            // 搜索框
            this.searchBoxBuilder();
          }
          .padding({
            end: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2),
            start: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2)
          })

          Stack() {
            Grid(undefined, this.allAppsParam.layoutOptions) {
              // 最近使用
              if (this.allAppsParam.recentAllApps.length > 0) {
                GridItem() {
                  Text($r('app.string.title_recently_use'))
                    .fontColor(GestureDockConstants.COLOR_TEXT_SECONDARY)
                    .fontSize(this.allAppsParam.fontScaleState.setFontScaleSize(
                      AllAppsConstants.SYS_SUBTITLE_SIZE, 1))
                    .width('100%')
                }
                .focusable(false)
                .height(AllAppsConstants.SYS_STANDARD_HEIGHT - this.allAppsParam.allAppsStyleConfig.gutter)
                .align(Alignment.BottomStart)
                .padding({
                  start: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2)
                })

                this.recentlyAppsBuilder()
              }
              // 支持智慧多窗的应用
              GridItem() {
                Text($r('app.string.title_support_multiWindow'))
                  .fontColor(GestureDockConstants.COLOR_TEXT_SECONDARY)
                  .fontSize(this.allAppsParam.fontScaleState.setFontScaleSize(AllAppsConstants.SYS_SUBTITLE_SIZE, 1))
                  .width('100%')
              }
              .focusable(false)
              .height(AllAppsConstants.SYS_STANDARD_HEIGHT - this.allAppsParam.allAppsStyleConfig.gutter)
              .align(Alignment.BottomStart)
              .padding({
                start: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2)
              })

              this.floatWindowAppsBuilder();
            }
            .cachedCount(AllAppsConstants.ALL_APPS_FLING_CACHE_COUNT)
            .flingSpeedLimit(AllAppsConstants.ALL_APPS_FLING_SPEED)
            .padding({ bottom: AllAppsConstants.ALL_APPS_BOTTOM_PADDING })
            .onAppear(() => {
              this.viewEventMgr.onAllAppsGridAppear();
            })
            .columnsTemplate(`repeat(auto-stretch, ${this.allAppsParam.allAppsStyleConfig?.itemWidth})`)
            .columnsGap(this.viewDataMgr.getColumnGutter(this.screenProperty.width))
            .rowsGap(this.allAppsParam.allAppsStyleConfig.gutter)
            .align(Alignment.TopStart)
            .blendMode(BLENDMODE_DESTINATION_IN, BlendApplyType.OFFSCREEN)
            .height(this.allAppsParam.contentsHeight)
            .scrollBar(BarState.Off)
            .edgeEffect(EdgeEffect.Spring)
          }
          .linearGradient({
            colors: [
              ['#00d8d8d8', 0],
              ['#ffDADADA',
                AllAppsConstants.ALL_APPS_RECENT_GRADIENT_TOP / this.allAppsParam.contentsHeight],
              ['#ffDADADA',
                1 - AllAppsConstants.ALL_APPS_RECENT_GRADIENT_BOTTOM / this.allAppsParam.contentsHeight],
              ['#00d8d8d8', 1]
            ]
          })
          .blendMode(BLENDMODE_SRC_OVER)
          .visibility(this.allAppsParam.isShowSearchResult ? Visibility.None : Visibility.Visible)

          if (this.allAppsParam.searchResultList.length > 0) {
            // 搜索结果
            this.searchResultBuilder()
          } else if (this.allAppsParam.isShowSearchResult){
            this.searchNoResultBuilder()
          }
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .padding({
          start: LengthMetrics.vp(this.allAppsParam.padding),
          end: LengthMetrics.vp(this.allAppsParam.padding)
        })
        .height('100%')
      }
      .margin({
        top: LengthMetrics.vp(ResUtils.getNumber($r('app.float.status_bar_phone_height'))),
        start: LengthMetrics.vp(GestureDockViewModel.getInstance().getViewData()?.getDockAllAppsMargin())
      })
      .height('100%')
      .width(GestureDockViewModel.getInstance().getViewData()?.getAllAppsWidth(this.screenProperty.width))
    }
    .onKeyPreIme((event: KeyEvent) => {
      log.showInfo(`onKeyPreIme event keyCode:${event.keyCode}`);
      if (event.keyCode === KeyCode.KEYCODE_MOVE_END) {
        return true;
      }
      if (event.keyCode === KeyCode.KEYCODE_MOVE_HOME) {
        focusControl.requestFocus(GestureDockConstants.ALL_APPS_TITLEBAR_ID);
      }
      return false;
    })
    .tabIndex(1)
    .backgroundEffect({
      policy: 1,
      radius: GestureDockConstants.ALL_APPS_BACKGROUND_RADIUS,
      saturation: 1.0,
      brightness: 1,
      color: GestureDockConstants.ALL_APPS_BACKGROUND_COLOR
    }, { disableSystemAdaptation: true })
    .onClick(() => {
      this.viewEventMgr.onBlankAreaClick();
    })
    .focusOnTouch(true)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
    .backgroundImage(this.allAppsParam.blurImage)
    .backgroundImageSize({ width: '100%', height: '100%' })
    .borderRadius(this.allAppsParam.borderRadius)
  }

  @Builder
  recentlyAppsBuilder() {
    ForEach(this.allAppsParam.recentAllApps, (item: GestureDockItemInfo, index: number) => {
      GridItem() {
        GestureDockAllAppsItemView({
          item: item,
          allAppsParam: this.allAppsParam,
          gestureDockAllAppsIcon: GestureDockAllAppsIcon.RECENT_APPS,
          dockAddAppSource: HiSysDockAddAppSourceData.EDIT_AREA,
          itemOnClick: (event?: ClickEvent) => {
            log.showInfo(`recentlyApps, dock onClick`);
            this.viewEventMgr.onAppItemClick(event, item, GestureDockAllAppsIcon.RECENT_APPS);
          }
        })
      }
      .align(Alignment.TopStart)
      .width('auto')
    }, (item: GestureDockItemInfo) => {
      return 'recent_allapp_' + item.bundleName + item.abilityName + item.appIndex;
    });
  }

  @Builder
  floatWindowAppsBuilder() {
    LazyForEach(this.viewDataMgr.allAppsDataSource, (item: GestureDockItemInfo, index: number) => {
      GridItem() {
        GestureDockAllAppsItemView({
          item: item,
          allAppsParam: this.allAppsParam,
          gestureDockAllAppsIcon: GestureDockAllAppsIcon.FLOAT_APPS,
          dockAddAppSource: HiSysDockAddAppSourceData.EDIT_AREA,
          itemOnClick: (event?: ClickEvent) => {
            log.showInfo(`floatWindowApps, dock onClick`);
            this.viewEventMgr.onAppItemClick(event, item, GestureDockAllAppsIcon.FLOAT_APPS);
          }
        })
          .reuseId(this.getItemReuseId(item))
      }
      .align(Alignment.TopStart)
      .width(this.allAppsParam.allAppsStyleConfig.iconSize)
      .margin({ top: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2 })
      .clip(false)
    }, (item: GestureDockItemInfo) => {
      return 'resident_allapp' + item.bundleName + item.abilityName + item.appIndex;
    });
  }

  @Builder
  searchResultBuilder() {
    Text($r('app.string.title_search_result'))
      .fontColor(GestureDockConstants.COLOR_TEXT_SECONDARY)
      .fontSize(this.allAppsParam.fontScaleState.setFontScaleSize(AllAppsConstants.SYS_SUBTITLE_SIZE, 1))
      .height(AllAppsConstants.SYS_STANDARD_HEIGHT - 2)
      .padding({
        start: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2)
      })
    List({ space: this.allAppsParam.allAppsStyleConfig.gutter }) {
      ForEach(this.allAppsParam.searchResultList, (item: GestureDockItemInfo, index: number) => {
        ListItem() {
          GestureDockAllAppsItemView({
            item: item,
            allAppsParam: this.allAppsParam,
            gestureDockAllAppsIcon: GestureDockAllAppsIcon.SEARCH_RESULT,
            dockAddAppSource: HiSysDockAddAppSourceData.SEARCH_RESULT,
            itemOnClick: (event?: ClickEvent) => {
              log.showInfo(`searchResult, dock onClick`);
              this.viewEventMgr.onAppItemClick(event, item, GestureDockAllAppsIcon.SEARCH_RESULT);
            }
          });
        }
        .padding({
          bottom: index === this.allAppsParam.searchResultList.length - 1 ? AllAppsConstants.ALL_APPS_BOTTOM_PADDING : 0
        })
        .width('auto')
      }, (item: GestureDockItemInfo) => {
        return 'recent_search' + item.bundleName + item.appIndex;
      });
    }
    .height(px2vp(this.screenProperty.height) - AllAppsConstants.SYS_STANDARD_HEIGHT * 3 -
      (viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea()?.height ?? 0) + 2)
    .scrollBar(BarState.Off)
    .lanes({ minLength: this.allAppsParam.allAppsStyleConfig?.itemWidth,
      maxLength: this.allAppsParam.allAppsStyleConfig?.itemWidth },
      this.viewDataMgr.getColumnGutter(this.screenProperty.width))
    .listDirection(Axis.Vertical)
    .onAppear(() => {
      this.viewEventMgr.onSearchResultListAppear();
    })
  }

  @Builder
  searchNoResultBuilder() {
    RelativeContainer() {
      Column() {
        Image($r('app.media.search_no_result'))
          .width(AllAppsConstants.ALL_APPS_SEARCH_NO_RESULT_WIDTH)
          .height(AllAppsConstants.ALL_APPS_SEARCH_NO_RESULT_HEIGHT)
          .draggable(false)
        Text($r('app.string.no_matching_results'))
          .fontColor(GestureDockConstants.COLOR_TEXT_SECONDARY)
          .fontSize(this.allAppsParam.fontScaleState.setFontScaleSize(AllAppsConstants.ALL_APPS_TEXT_SIZE_BODY2, 1))
          .opacity(0.7)
          .margin({ top: 16 })
          .draggable(false)
      }
      .width('auto')
      .height('auto')
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      })
      .markAnchor({ y: '50%' })
    }
  }

  @Builder
  titleBarBuilder() {
    Row() {
      Stack() {
        Image($r('app.media.ic_public_arrow_left_filled'))
          .width(AllAppsConstants.ALL_APPS_TITLE_ICON_SIZE)
          .height(AllAppsConstants.ALL_APPS_TITLE_ICON_SIZE)
          .fillColor(GestureDockConstants.COLOR_TEXT_PRIMARY)
          .draggable(false)
          .matchTextDirection(true)
      }
      .groupDefaultFocus(true)
      .alignContent(Alignment.Center)
      .width(AllAppsConstants.GESTURE_DOCK_ICON_SIZE)
      .height(AllAppsConstants.GESTURE_DOCK_ICON_SIZE)
      .borderRadius(AllAppsConstants.GESTURE_DOCK_ICON_SIZE / 2)
      .backgroundColor('#0C000000')
      .onClick(() => {
        this.viewEventMgr.onArrowLeftClick();
      })

      Text($r('app.string.title_all_apps'))
        .fontSize(this.allAppsParam.fontScaleState.setFontScaleSize(AllAppsConstants.ALL_APPS_TITLE_ICON_SIZE, 1))
        .fontColor(GestureDockConstants.COLOR_TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ start: LengthMetrics.vp(10) })
    }
    .id(`${TAG}_titleBarBuilder`)
    .width(this.viewDataMgr.getSearchBoxWidth(this.screenProperty.width))
    .height(AllAppsConstants.SYS_STANDARD_HEIGHT)
  }

  @Builder
  searchBoxBuilder() {
    Row() {
      Search({
        placeholder: $r('app.string.search_apps'),
        value: this.allAppsParam.searchText
      })
        .fontColor(GestureDockConstants.COLOR_TEXT_PRIMARY)
        .placeholderColor($r('app.color.color_text_secondary'))
        .placeholderFont({
          size: this.allAppsParam.fontScaleState.setFontScaleSize(AllAppsConstants.SYS_TEXTSIZE_BODY, 1),
        })
        .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontColor([$r('app.color.color_text_secondary')])
          .fontSize('16vp'))
        .cancelButton({
          icon: new SymbolGlyphModifier($r('sys.symbol.xmark')).fontColor([$r('app.color.color_text_secondary')])
            .fontSize('16vp')
        })
        .textFont({ size: this.allAppsParam.fontScaleState.setFontScaleSize(AllAppsConstants.SYS_TEXTSIZE_BODY, 1) })
        .align(Alignment.Start)
        .focusable(this.allAppsParam.searchBoxFocusable)
        .onClick(() => {
          this.viewEventMgr.onSearchBoxClick();
        })
        .onChange((value: string) => {
          this.viewEventMgr.onSearchTextChange(value);
        })
        .onBlur(() => {
          this.viewEventMgr.onBlur();
        })
        .key(`${TAG}_Search_Row`)
        .backgroundColor($r('app.color.color_white_20'))
        .borderRadius(AllAppsConstants.ALL_APPS_SEARCH_RADIUS)
    }
    .width(this.viewDataMgr.getSearchBoxWidth(this.screenProperty.width))
    .height(AllAppsConstants.SYS_STANDARD_HEIGHT)
  }

  private getItemReuseId(item: GestureDockItemInfo): string {
    if (item.bundleName === CommonConstants.CALENDAR_BUNDLE) {
      return 'AllAppsBubbleCalendar';
    } else if (item.bundleName === CommonConstants.CLOCK_BUNDLE) {
      return 'AllAppsBubbleClock';
    } else {
      return 'AllAppsBubble';
    }
  }
}