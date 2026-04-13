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

import type image from '@ohos.multimedia.image';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import { LiveExtendType, LiveIconName, LiveType, OtherFormExtendShowType } from '../../common/LiveConstants';
import { OtherBaseTemplate } from './OtherBaseTemplate';
import { LiveViewData } from '../LiveViewData';
import { LiveOtherExtendData } from '../extend/LiveOtherExtendData';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveNavTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface NavDirection {
  icon: image.PixelMap;
  iconKey: string;
}

/**
 * 实况卡片模板，导航类型模板
 * 固定区：主副文本，主文本存放导航详细信息，存在LiveBaseTemplate的title字段。副文本存放多个目的地信息，存在LiveBaseTemplate的richContent字段；
 * 辅助区：应用图标，存在LiveBaseTemplate的richContent字段；
 * 拓展区：分上下拓展区，上拓展区存放当前导航方向，存在currNavDirectionIcon字段。下拓展区存放导航方向图标，存在；
 * 分割线：上下区有分割线隔离
 *
 * @see LiveBaseTemplate
 */
@Observed
export class LiveNavigationTemplate extends OtherBaseTemplate {
  /**
   * 上拓展区，当前导航方向图片
   */
  currNavDirectionIcon?: image.PixelMap;

  /**
   * 上拓展区，当前导航方向图片路径
   */
  currNavDirectionIconRes?: string;

  /**
   * 下拓展区，导航方向图片列表
   */
  navDirectionIcons?: Array<NavDirection>;

  /**
   * 下拓展区，导航方向图片列表路径
   */
  navDirectionIconsRes?: Array<string>;

  /**
   * 是否展示导航方向的箭头集合图片
   */
  isNavigationIconsDisplayed?: boolean = true;

  /**
   * 是否显示扩展区分割线
   */
  isDisplayHorizontalLine?: boolean = true;

  /**
   * 导航方向图片类型
   */
  layoutNavigationIconMimeType: string;

  /**
   * 判断是否不带导航方向列表的导航模板
   * 如果有导航方向列表，则为2 * 4布局，卡片高度选144
   * 如果无导航方向列表，则为1 * 4布局，卡片高度选66
   *
   * @param data 实况窗数据
   * @returns true 2*4布局，高度选144；false 1*4布局，高度选66
   */
  static isNavigationWithoutDirections(data: LiveViewData): boolean {
    if (data.liveType !== LiveType.NAVIGATION) {
      return false;
    }

    let template = data.template as LiveNavigationTemplate;
    if (!template.navDirectionIcons?.length && !template.navDirectionIconsRes?.length) {
      return true;
    }

    return false;
  }

  getLiveType(): LiveType {
    return LiveType.NAVIGATION;
  }

  update(other: object, forceRefresh?: boolean, bundleName?: string): void {
    if (!(other instanceof LiveNavigationTemplate)) {
      return;
    }

    super.update(other, forceRefresh);

    let otherTemplate = other as LiveNavigationTemplate;
    this.setCurrNavDirectionIcon(otherTemplate.currNavDirectionIcon, forceRefresh || otherTemplate.clearImgForUpdate[LiveIconName.CURRNAVDIRECTION_ICON_NAME]);
    this.setCurrNavDirectionIconRes(otherTemplate.currNavDirectionIconRes, forceRefresh);
    this.setNavDirectionIcons(otherTemplate.navDirectionIcons, forceRefresh);
    this.setNavDirectionIconsRes(otherTemplate.navDirectionIconsRes, forceRefresh);
    this.setIsNavigationIconsDisplayed(otherTemplate.isNavigationIconsDisplayed, forceRefresh);
    this.setDisplayHorizontalLine(otherTemplate.isDisplayHorizontalLine, forceRefresh);
    this.setNavigationIconMimeType(otherTemplate.layoutNavigationIconMimeType, forceRefresh);
    log.showInfo('update LiveNavigationTemplate');
  }

  setCurrNavDirectionIcon(currNavDirectionIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(currNavDirectionIcon)) {
      if (this.currNavDirectionIcon === currNavDirectionIcon) {
        return;
      }
      this.currNavDirectionIcon?.release();
      this.currNavDirectionIcon = currNavDirectionIcon;
    }
  }

  setCurrNavDirectionIconRes(currNavDirectionIconRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(currNavDirectionIconRes)) {
      this.currNavDirectionIconRes = currNavDirectionIconRes;
    }
  }

  setNavDirectionIconsFromPixel(navDirectionIcons?: Array<image.PixelMap>, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(navDirectionIcons)) {
      for (let i = 0; i < this.navDirectionIcons?.length; i++) {
        this.navDirectionIcons[i].icon?.release();
      }

      this.navDirectionIcons = navDirectionIcons?.map(icon => {
        return { icon, iconKey: Date.now().toString() };
      });
    }
  }

  setNavDirectionIcons(navDirectionIcons?: Array<NavDirection>, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(navDirectionIcons)) {
      for (let i = 0; i < this.navDirectionIcons?.length; i++) {
        if (this.navDirectionIcons[i].icon === navDirectionIcons[i]?.icon) {
          continue;
        }
        this.navDirectionIcons[i].icon?.release();
      }
      this.navDirectionIcons = navDirectionIcons;
    }
  }

  setNavDirectionIconsRes(navDirectionIconsRes?: Array<string>, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(navDirectionIconsRes)) {
      this.navDirectionIconsRes = navDirectionIconsRes;
    }
  }

  setIsNavigationIconsDisplayed(isNavigationIconsDisplayed?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isNavigationIconsDisplayed)) {
      this.isNavigationIconsDisplayed = isNavigationIconsDisplayed;
    }
  }

  setDisplayHorizontalLine(isDisplayHorizontalLine?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isDisplayHorizontalLine)) {
      this.isDisplayHorizontalLine = isDisplayHorizontalLine;
    }
  }

  setNavigationIconMimeType(layoutNavigationIconMimeType?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(layoutNavigationIconMimeType)) {
      this.layoutNavigationIconMimeType = layoutNavigationIconMimeType;
    }
  }

  hasExtendPic(): boolean {
    const extendType = LiveExtendType.TYPE_OTHER_EXTEND;
    const extendData = this.getExtendData(extendType) as LiveOtherExtendData;
    if (extendData.type === OtherFormExtendShowType.PICTURE && extendData.pic) {
      return true;
    }
    return false;
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    super.releaseImages();
    if (this.currNavDirectionIconRes) {
      log.showInfo('release currNavDirectionIcon');
      this.currNavDirectionIcon?.release();
    }
    if (!ArrayUtils.isEmpty(this.navDirectionIconsRes)) {
      log.showInfo('release navDirectionIcons');
      this.navDirectionIcons?.forEach(dirIcon => dirIcon?.icon?.release());
    }
  }
}