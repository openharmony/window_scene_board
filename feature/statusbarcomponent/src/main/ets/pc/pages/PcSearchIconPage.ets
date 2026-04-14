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

import { common, Want } from '@kit.AbilityKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { StyleManager } from '../style/PluginStyleManager';
import { PluginProperty } from '../viewdata/PluginProperty';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { DeviceHelper,
  GlobalSearchConstants,
  GlobalSearchStatus,
  PluginIconType, sOutSideWindowMgr, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { PluginStyle } from '../style/PluginStyle';
import { StyleType } from '../utils/enum';
import display from '@ohos.display';
import { util } from '@kit.ArkTS';
import { CommonUtils } from '../utils/CommonUtils';
import { PluginWindowManager } from '../pluginwindow/PluginWindowManager';

export const WINDOW_MARGIN_LEFT = 242;

export const WINDOW_MARGIN_TOP = 190;

const TAG = 'PcSearchIconPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const WHITE: string = '#FFFFFF';

@Entry
@Component
export struct PcSearchIconPage {
  @State containerBackgroundColor: string | Resource = $r('app.color.plugin_icon_color_bg_none');
  @State vp2pxScale: number = 1.9;
  @State searchIconSize: number = 20;
  @State searchLeftPadding: number = 6;
  @State searchRightPadding: number = 6;
  @Consume contentColor: string;
  @ObjectLink property: PluginProperty;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear hash: ${util.getHash(this)}`);
    let productModel = deviceInfo.productModel;
    if (productModel.includes('HYM')) {
      this.vp2pxScale = 1.25;
    } else {
      this.vp2pxScale = CommonUtils.calcVp2pxScale();
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear hash: ${util.getHash(this)}`);
  }

  fpToFixedPx(fp: number): string {
    return `${fp * this.vp2pxScale}px`;
  }

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.AI_search'))
        .fontWeight(FontWeight.Bold)
        .fontSize(this.fpToFixedPx(this.searchIconSize))
        .draggable(false)
        .fontColor([this.contentColor])
        .width(this.searchIconSize)
        .height(this.searchIconSize)
        .renderGroup(true)
        .opacity(0.9)

      Text($r('app.string.search'))
        .fontSize(this.fpToFixedPx(14))
        .fontColor(this.contentColor)
        .fontFamily('HarmonyHeiTi')
        .lineHeight(this.fpToFixedPx(19))
        .fontWeight(FontWeight.Medium)
        .id(`${TAG}_text_search`)
        .margin({ start: LengthMetrics.vp(this.searchLeftPadding) })
        .textShadow({
          offsetX: 0,
          offsetY: 1,
          radius: 2,
          color: $r('app.color.search_textShadow')
        })
        .maxLines(1)
        .renderGroup(true)
        .onSizeChange(this.onIconAreaChange)
    }
    .padding({ start: LengthMetrics.vp(this.searchLeftPadding), end: LengthMetrics.vp(this.searchRightPadding) })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .borderRadius(8)
    .width('100%')
    .height('100%')
    .backgroundColor(this.containerBackgroundColor)
    .onTouch((event) => {
      if (event.type === TouchType.Down) {
        this.containerBackgroundColor = this.getCurrentBgColorByContentColor(true);
      } else if (event.type === TouchType.Up) {
        this.containerBackgroundColor =
          event.sourceTool === 1 ? $r('app.color.plugin_icon_color_bg_none') : this.getCurrentBgColorByContentColor();
        if (DeviceHelper.is2In1DevicePcType()) {
          this.dealSearchIconEventInDevicePcType();
        } else {
          this.dealSearchIconEventInPc();
        }
      }
    })
    .onHover((isHover) => {
      if (isHover) {
        this.containerBackgroundColor = this.getCurrentBgColorByContentColor()
      } else {
        this.containerBackgroundColor = $r('app.color.plugin_icon_color_bg_none');
      }
    })
  }

  private dealSearchIconEventInPc(): void {
    try {
      let context = getContext(this) as common.UIAbilityContext;
      let displayId: number = display.getDefaultDisplaySync()?.id;
      let currentDisplayId: number | undefined = context.config?.displayId;
      if (typeof (currentDisplayId) === 'number' && currentDisplayId >= 0) {
        displayId = currentDisplayId;
      }
      log.showInfo(`start hisearch displayId：${displayId}`);
      const wantInfo: Want = {
        bundleName: 'com.ohos.hisearch',
        abilityName: 'MainAbility'
      };
      context.startAbility(wantInfo, { displayId });
    } catch (err) {
      log.showError(`start hisearch error, error: ${err?.message}, code: ${err?.code}`);
    }
  }

  private dealSearchIconEventInDevicePcType(): void {
    const lastGlobalSearchState = sOutSideWindowMgr.isShowGlobalSearch();
    const isGlobalSearchViewShow: boolean = ViewManagerPolicy.isViewShowing(ViewType.GLOBAL_SEARCH);
    if (lastGlobalSearchState && isGlobalSearchViewShow) {
      this.hideGlobalSearch();
    } else if (!lastGlobalSearchState || !isGlobalSearchViewShow ) {
      PluginWindowManager.getInstance().hideAppOrRecentWindow();
      this.showGlobalSearch();
    }
  }

  public showGlobalSearch(): void {
    log.showInfo('gs showGlobalSearch start');
    sOutSideWindowMgr.setIsHidingGlobalSearch(false);
    sOutSideWindowMgr.setDesktopEnabled(false, TAG);
    // start show animation
    log.showInfo('intoSearch:start');
    ViewManagerPolicy.showView(ViewType.GLOBAL_SEARCH);
    sOutSideWindowMgr.setGlobalSearchTranslateY(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.SHOW);
    animateTo({
      curve: curves.springMotion(),
      onFinish: () => {
        sOutSideWindowMgr.setDesktopEnabled(true, TAG);
        log.showInfo('intoSearch:end');
      }
    }, () => {
      sOutSideWindowMgr.showGlobalSearchDirectly();
      sOutSideWindowMgr.setGlobalSearchOpacity(1);
    })
  }

  public hideGlobalSearch(): void {
    log.showInfo(`hide Global search`);
    sOutSideWindowMgr.hideGlobalSearch();
  }

    /**
   * 根据壁纸深浅色改变图标背景色
   */
  private getCurrentBgColorByContentColor(isTouchDown: boolean = false): string | Resource {
    // 优先选中状态
    if (isTouchDown) {
      return this.contentColor === WHITE ? '#26FFFFFF' : '#19000000';
    }
    // 其次hover状态
    return this.contentColor === WHITE ? '#19FFFFFF' : '#0C000000';
  }

  /**
   * 图标宽度变化
   *
   * @param oldArea 旧区域
   * @param newArea 新区域
   */
  private onIconAreaChange = (oldArea: SizeOptions, newArea: SizeOptions): void => {
    let width = (newArea?.width as number) ?? 0;
    // 自适应宽度场景，随图标宽度自适应
    if (this.isWidthAutoType() && width != 0) {
      let style = StyleManager.getInstance()
        .requestStyle(StyleType.PLUGIN, this.property.getSlot()) as PluginStyle;
      if (style) {
        style.iconRequestWidth = width + this.searchIconSize + this.searchLeftPadding * 2 + this.searchRightPadding;
        log.showInfo(`onIconAreaChange, iconRequestWidth: ${style.iconRequestWidth}, width: ${width}`);
      }
    }

  }

  /**
   * 是否为宽度自适应
   *
   * @return 是否宽度自适应
   */
  private isWidthAutoType(): boolean {
    let iconType = this.property.pluginInfo?.pluginParseInfo?.pluginIconType;
    return iconType == PluginIconType.TYPE_AUTO_ICON;
  }
}

export default PcSearchIconPage;