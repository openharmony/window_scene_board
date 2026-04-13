/*
 *
 *  Copyright (c) 2025 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import { DataModel, FLCardData } from '@hw-flexiblelayout/flexiblelayout';

/**
 * 智能体服务助手动态布局数据。
 */
export class AgentServiceAssistantCardData extends FLCardData {
  public cardViewCss: CardViewCss;
  public displayCss: DisplayCss;
  public guidesCss: GuidesCss;
  public chipsCss: ChipsCss;

  constructor(data: DataModel) {
    super(data);
    this.cardViewCss = this.opt('cardViewCss');
    this.displayCss = this.opt('displayCss');
    this.guidesCss = this.opt('guidesCss');
    this.chipsCss = this.opt('chipsCss');
  }
}

/**
 * 智能体服务助手常驻卡整体动态布局数据。
 */
export class CardViewCss {
  public paddingStart: number = 0;
  public paddingEnd: number = 0;
  public paddingTop: number = 0;
  public paddingBottom: number = 0;

  public marginTop: number = 0;
  public marginBottom: number = 0;
}

/**
 * 智能体服务助手常驻卡展示内容动态布局数据。
 */
export class DisplayCss {
  public marginTop: number = 0;
  public marginBottom: number = 0;

  public titleFontSize: number = 0;
  public titleLineHeight: number = 0;

  public subTitleFontSize: number = 0;
  public subTitleLineHeight: number = 0;
}

/**
 * 智能体服务助手常驻卡引导语动态布局数据。
 */
export class GuidesCss {
  public iconSideLength: number = 0;
  public iconMarginEnd: number = 0;

  public textFontSize: number = 0;

  public guideBorderRadius: number = 0;
  public guideHeight: number = 0;
  public guidePaddingStart: number = 0;
  public guidePaddingEnd: number = 0;

  public linePaddingStart: number = 0;
  public linePaddingEnd: number = 0;
  public lineMarginTop: number = 0;
  public lineMarginBottom: number = 0;

  public swiperInterval: number = 0;
}

/**
 * 智能体服务助手常驻卡条状标签动态布局数据。
 */
export class ChipsCss {
  public textFontSize: number = 0;
  public textFontColor: string = '';
  public textLineHeight: number = 0;

  public chipMaxWidth: string = '';
  public chipBgColor: string = '';
  public chipPaddingTop: number = 0;
  public chipPaddingBottom: number = 0;
  public chipPaddingStart: number = 0;
  public chipPaddingEnd: number = 0;
  public chipMarginStart: number = 0;
  public chipMarginEnd: number = 0;

  public lineMarginTop: number = 0;
  public lineMarginBottom: number = 0;
}
