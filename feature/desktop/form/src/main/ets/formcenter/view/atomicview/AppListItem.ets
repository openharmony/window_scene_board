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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppItemInfo';
import { AppListItemStyle } from '../../viewstyles/AppListItemStyle';
import { AppListItemInterface } from '../../interfaces/AppListInterface';
import { AppListItemEvent, FormAppItemInfo } from '../../viewmodel/event/AppListEvent';
import { SearchStateMgr } from './SearchComponent';
import { SingleAppResult } from '../../util/FusionSearchUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'FormAppListItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct AppListItem {
  public idIndex: number = 0;
  public appItem: AppItemInfo = new AppItemInfo();
  public style: AppListItemStyle = new AppListItemStyle();
  public appItemViewEvent: AppListItemInterface = AppListItemEvent.getInstance();
  private imageId: string = '';
  private appNameId: string = '';
  private displayNameId: string = '';
  private arrowId: string = '';

  @State appNameSearchResult: string[] = [];
  @State displayNameSearchResult: string[] = [];
  @State isShowResult: boolean = false;

  @State isHover: boolean = false;
  @State formAppInfo: FormAppItemInfo = new FormAppItemInfo();
  @Prop @Watch('refreshSearchResult') refreshFlag: boolean = false;
  @Prop clickIndex: number = 0;

  private refreshSearchResult(): void {
    this.isShowResult = SearchStateMgr.getInstance().getIsShowSearchResult();
    if (!this.isShowResult) {
      return;
    }

    let searchResult: SingleAppResult | undefined =
      SearchStateMgr.getInstance().parsedSearchResult.get(this.appItem.bundleName);
    this.appNameSearchResult = this.getHighLightArr(searchResult?.appName ?? '');

    let displayNameMap: Map<string, string> = searchResult?.descriptionMap ?? new Map();
    let displayNameArr: string[] = Array.from(new Set(displayNameMap.values()));
    let displayName: string = this.appItemViewEvent.getDisplayNameWithFormatter(displayNameArr);
    this.displayNameSearchResult = this.getHighLightArr(displayName);
    log.showDebug(`refreshSearchResult appName: ${this.appNameSearchResult}, display: ${this.displayNameSearchResult}`);
  }

  private initComponentId(): void {
    this.imageId = `${TAG}_Image_icon_${this.formAppInfo.appName}_${this.idIndex}`;
    this.appNameId = `${TAG}_Text_Appname_${this.appItem.bundleName}_${this.idIndex}`;
    this.displayNameId = `${TAG}_Text_DisplayName_${this.appItem.bundleName}_${this.idIndex}`;
    this.arrowId = `${TAG}_Image_arrowRight_${this.idIndex}`;
  }

  private getHighLightArr(highlightStr: string): string[] {
    if (CheckEmptyUtils.checkStrIsEmpty(highlightStr)) {
      log.showWarn('highlight string is empty!');
      return [];
    }

    return highlightStr.split(/(<em>|<\/em>)/i);
  }

  private showDisplayName(): boolean {
    return this.isShowResult && !CheckEmptyUtils.isEmptyArr(this.displayNameSearchResult);
  }

  aboutToAppear(): void {
    this.appItemViewEvent.updateServiceFormAppInfo(this.appItem, this.formAppInfo);
    this.initComponentId();
    this.refreshSearchResult();
    log.showDebug(`current appsize:${this.style.appSize}, isneedArrow:${this.style.isNeedArrow}`);
  }

  public getBackgroundColor(): ResourceColor | undefined {
    if (this.clickIndex === this.idIndex) {
      return AppStorage.get('currColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
        this.style.selectColorDark : this.style.selectColor;
    }
    if (this.isHover) {
      return this.style.hoverColor;
    }
    return undefined;
  }

  @Styles
  normalStyle(): void {
    .border({
      color: this.style.defaultBorderColor,
      width: this.style.defaultBorderWidth,
      radius: this.style.itemRadius
    })
    .backgroundColor(this.getBackgroundColor())
  }

  @Styles 
  pressStyle() {
    .border({
      color: this.style.defaultBorderColor,
      width: this.style.defaultBorderWidth,
      radius: this.style.itemRadius
    })
    .backgroundColor(this.style.pressColor)
  }

  @Styles
  focusedStyle(): void {
    .border({
      color: this.style.innerFocusColor,
      width: this.style.innerFocusWidth,
      radius: this.style.itemRadius
    })
    .backgroundColor(this.getBackgroundColor())
  }

  build() {
    RelativeContainer() {
      Image(this.formAppInfo.icon)
        .draggable(false)
        .autoResize(this.style.autoResize)
        .border(this.style.appBorder)
        .id(this.imageId)
        .width(this.style.appSize)
        .height(this.style.appSize)
        .borderRadius(this.style.appRadius)
        .interpolation(this.style.interpolation)
        .alignRules({
          start: { anchor: '__container__', align: HorizontalAlign.Start },
          center: { anchor: '__container__', align: VerticalAlign.Center },
        })
        .margin(this.style.appMargin)
        .padding(this.style.appPadding)
        .syncLoad(true)

      Text(this.formAppInfo.appName) {
        if (this.isShowResult) {
          ForEach(this.appNameSearchResult, (str: string, index: number) => {
            if (str !== '<em>' && str !== '</em>') {
              Span(str).fontColor(this.appNameSearchResult[index - 1] === '<em>' ?
              $r('sys.color.font_emphasize') : undefined)
            }
          })
        }
      }
      .height(this.showDisplayName() ? '50%' : '100%')
      .draggable(false)
      .focusable(this.style.needInnerFocusStyle)
      .id(this.appNameId)
      .fontSize(this.style.textFontSize)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontWeight(this.idIndex === this.clickIndex ? this.style.selectTextFontWeight : this.style.textFontWeight)
      .maxLines(this.style.maxLines)
      .lineHeight(this.style.lineHeight)
      .textOverflow({ overflow: this.style.textOverflow })
      .layoutWeight(this.style.layoutWeight)
      .margin(this.style.appNameMargin)
      .padding(this.style.textPadding)
      .maxFontScale(this.style.maxFontScale)
      // 取消连字，防止span规定的标蓝范围被连字覆盖
      .fontFeature('"liga" off')
      .align(this.showDisplayName() ? Alignment.Bottom : undefined)
      .alignRules({
        start: { anchor: this.imageId, align: HorizontalAlign.End },
        top: this.showDisplayName() ? { anchor: '__container__', align: VerticalAlign.Top } : undefined,
        bottom: this.showDisplayName() ? { anchor: '__container__', align: VerticalAlign.Center } : undefined,
        center: this.showDisplayName() ? undefined : { anchor: '__container__', align: VerticalAlign.Center },
      })

      if (this.showDisplayName()) {
        Text() {
          ForEach(this.displayNameSearchResult, (str: string, index: number) => {
            if (str !== '<em>' && str !== '</em>') {
              Span(str).fontColor(this.displayNameSearchResult[index - 1] === '<em>' ?
              $r('sys.color.ohos_id_color_text_primary_activated') : undefined)
            }
          })
        }
        .height('50%')
        .draggable(false)
        .focusable(this.style.needInnerFocusStyle)
        .id(this.displayNameId)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Regular)
        .maxLines(this.style.maxLines)
        .lineHeight(this.style.lineHeight)
        .textOverflow({ overflow: this.style.textOverflow })
        .layoutWeight(this.style.layoutWeight)
        .margin(this.style.appNameMargin)
        .padding(this.style.disPlayNamePadding)
        .maxFontScale(this.style.maxFontScale)
        // 取消连字，防止span规定的标蓝范围被连字覆盖
        .fontFeature('"liga" off')
        .align(this.isShowResult ? Alignment.Top : undefined)
        .alignRules({
          start: { anchor: this.imageId, align: HorizontalAlign.End },
          top: { anchor: '__container__', align: VerticalAlign.Center },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          end: this.style.isNeedArrow ? { anchor: this.arrowId, align: HorizontalAlign.Start } :
            { anchor: '__container__', align: HorizontalAlign.End },
        })
      }

      if (this.style.isNeedArrow) {
        Image(this.style.rightArrowIcon)
          .draggable(false)
          .matchTextDirection(true)
          .id(this.arrowId)
          .width(DeviceHelper.isPC() ? '8%' : this.style.arrowWidth)
          .height(DeviceHelper.isPC() ? '15%' : this.style.arrowHeight)
          .fillColor(this.style.arrowFillColor)
          .alignRules({
            end: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          })
      }
    }
    .key(`App_List_Item_Group_${this.idIndex}`)
    .focusScopeId(`App_List_Item_Group_${this.idIndex}`, true)
    .width(DeviceHelper.isPC() ? '100%' : this.style.itemWidth)
    .height(this.isShowResult ? (this.style.itemHeightSearch ?? this.style.itemHeight) : this.style.itemHeight)
    .stateStyles({
      normal: this.normalStyle,
      pressed: this.pressStyle,
      focused: this.focusedStyle
    })
    .onHover((isHover: boolean) => {
      this.isHover = isHover;
    })
    .borderRadius(this.style.itemRadius)
    .padding(this.style.rowPadding)
    .margin(this.style.rowMargin)
  }
}