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

import { LengthMetrics } from '@kit.ArkUI';
import { AppItemInfo, StyleConstants, PageDesktopModel } from '@ohos/launchercommon'
import { LogHelper, LogDomain, CheckEmptyUtils, SingleContext } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import ThisStyleConstants from '../constants/FormStyleConstants';
import { AppItemStyle, ServiceAppItemInfo, ServiceFormAppItemConfig } from '../ServiceFormAppItemConfig';
import { NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';

const TAG = 'ServiceFormAppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct ServiceFormAppItem {
  @Prop singleContext?: SingleContext;
  rightArrowIconWidth: number = ThisStyleConstants.SERVICE_FORM_APP_ITEM_RIGHT_ARROW_WIDTH;
  rightArrowIconHeight: number = ThisStyleConstants.SERVICE_FORM_APP_ITEM_RIGHT_ARROW_HEIGHT;
  bundleName: string = '';
  abilityName: string = '';
  moduleName: string = '';
  appLabelId: number = 0;
  iconId: number = 0;
  clickApp?: Function;
  private icon: string = '';
  private appName: string = '';
  private item?: AppItemInfo;
  private mIconSize: number = ThisStyleConstants.FORM_SERVICE_APP_ICON_SIZE_WIDTH;
  private mNameLines: number = PageDesktopModel.getInstance().getPageDesktopStyleConfig().mMaxNameLines;
  private mNameMarginLeft: number = ThisStyleConstants.FORM_SERVICE_APP_NAME_MARGIN_LEFT;
  private mAppItemHeight: number = ThisStyleConstants.FORM_SERVICE_APP_ITEM_HEIGHT;
  private idIndex: number = 0;
  private mInterpolation: ImageInterpolation = ImageInterpolation.None;
  private appItemInfo: ServiceAppItemInfo = new ServiceAppItemInfo();
  private serviceFormAppItemConfig: ServiceFormAppItemConfig = ServiceFormAppItemConfig.getInstance();
  private mNoIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @State appItemStyle: AppItemStyle = new AppItemStyle();
  @Prop @Watch('updateSearchResult') matchedText: string = '';
  @State searchResult: string[] = [];

  aboutToAppear(): void {
    this.appItemInfo.bundleName = this.bundleName;
    this.appItemInfo.abilityName = this.abilityName;
    this.appItemInfo.moduleName = this.moduleName;
    this.appItemInfo.appLabelId = this.appLabelId;
    this.appItemInfo.iconId = this.iconId;
    this.appItemStyle.appName = this.appName;
    this.appItemStyle.icon = this.icon;
    this.mInterpolation = ImageInterpolation.Medium;
    if (this.mNoIconAppModel.checkIfBundleIsNoIconApp(this.bundleName)) {
      this.serviceFormAppItemConfig.updateNoIconAppInfo(this.bundleName, this.appItemStyle);
      this.updateSearchResult();
      return;
    }
    this.serviceFormAppItemConfig.updateIcon(this.appItemInfo, this.appItemStyle);
    this.serviceFormAppItemConfig.updateName(this.appItemInfo, this.appItemStyle);
    this.updateSearchResult();
  }

  private updateSearchResult() {
    this.searchResult = this.serviceFormAppItemConfig.updateSearchResult(this.matchedText, this.appItemStyle);
  }

  private onLanguageChange(): void {
    log.showInfo(`onLanguageChange ${this.language}`);
    if (this.mNoIconAppModel.checkIfBundleIsNoIconApp(this.bundleName)) {
      this.serviceFormAppItemConfig.updateNoIconAppInfo(this.bundleName, this.appItemStyle);
      return;
    }
    this.serviceFormAppItemConfig.updateNameWhenLanguageChange(this.appItemInfo, this.appItemStyle);
  }

  @Styles normalStyle() {
    .backgroundColor(null)
  }

  @Styles pressStyle() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
  }

  build() {
    Row() {
      Image(this.appItemStyle.icon).draggable(false)
        .border(ServiceFormAppItemConfig.imageStyle().border)
        .id(`${TAG}_Image_icon_${this.bundleName}_${this.idIndex}`)
        .width(this.mIconSize)
        .height(this.mIconSize)
        .borderRadius(this.serviceFormAppItemConfig.getServiceFormAppItemImageRadius())
        .autoResize(false)
        .interpolation(this.mInterpolation)

      Text() {
        if (CheckEmptyUtils.checkStrIsEmpty(this.searchResult?.[1])) {
          Span(this.appItemStyle.appName)
        } else {
          Span(this.searchResult[0])
          Span(this.searchResult[1]).fontColor($r('sys.color.font_emphasize'))
          Span(this.searchResult[2])
        }
      }
      .draggable(false)
      .id(`${TAG}_Text_appName_${this.bundleName}_${this.idIndex}`)
      .fontSize($r('sys.float.ohos_id_text_size_body1'))
      .fontColor(ServiceFormAppItemConfig.textStyle().fontColor)
      .fontWeight(ResourceManager.getInstance().getFontWeightMedium())
      .lineHeight(ThisStyleConstants.FORM_SERVICE_APP_NAME_LINE_HEIGHT)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(this.mNameLines)
      .margin({ start: LengthMetrics.vp(this.mNameMarginLeft) })
      .layoutWeight(1)
      .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
      // 取消连字，防止span规定的标蓝范围被连字覆盖
      .fontFeature('"liga" off')

      Image(ServiceFormAppItemConfig.imageStyle().imageIcon)
        .draggable(false)
        .id(`${TAG}_Image_arrowRight_${this.idIndex}`)
        .width(this.rightArrowIconWidth)
        .height(this.rightArrowIconHeight)
        .fillColor(ServiceFormAppItemConfig.imageStyle().fillColor)
        .matchTextDirection(true)
    }
    .alignItems(VerticalAlign.Center)
    .width(StyleConstants.PERCENTAGE_100)
    .height(this.mAppItemHeight)
    .stateStyles({
      normal: this.normalStyle,
      pressed: this.pressStyle
    })
    .padding({
      left: ThisStyleConstants.FORM_APP_LIST_ITEM_PADDING,
      right: ThisStyleConstants.FORM_APP_LIST_ITEM_PADDING
    })
    .borderRadius(ThisStyleConstants.FORM_APP_LIST_ITEM_RADIUS)
    .onClick((event: ClickEvent) => {
      log.showInfo(`formServicePanel appItem click, bundleName: ${this.bundleName}`);
      if (this.clickApp) {
        this.clickApp(event, this.item);
      }
    })
  }
}