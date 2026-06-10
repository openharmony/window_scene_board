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

import ConfigData from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { LengthMetrics } from '@ohos.arkui.node';
import { StateNumberValue } from '../vm/NotificationMgmtViewData';
import measure from '@ohos.measure';

const TAG = 'ManagementComponent-SelectComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_SELECT = TAG + '_Select';
const MENU_LINE_HEIGHT = 21;
const SELECTED_MARK_SIZE = 22;
const SELECTED_MARK_MARGIN = 8;

@Component
export default struct SelectComponent {
  private title: ResourceStr = '';
  private settingAction?: (index: number) => void;
  @State maxItemIndex: number = 0;
  @Require private opts: ResourceStr[] = [];
  @State private menuItemVms: MenuItemVm[] = [];
  @ObjectLink @Watch('selectedIndexChange') selectedIndex: StateNumberValue;
  @State selectBackgroundColor: ResourceColor = Color.Transparent;
  @State itemMaxWidth?: Length = undefined;
  @State isShowMenu: boolean = false;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear SelectComponent');
    this.menuItemVms = this.opts2MenuItemVms(this.opts);
    this.updateSelectValue();
    this.getMaxItemIndex();
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      this.buildSelectLabel();
      this.buildSelect();
    }.width(ConfigData.WH_100_100)
  }

  @Builder
  buildSelectLabel() {
    Row() {
      Text(this.title)
        .draggable(false)
        .id(COMPONENT_ID_TITLE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .lineHeight(22)
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .align(Alignment.Start)
        .margin({ top: 9, bottom: 9 })
    }
    .alignItems(VerticalAlign.Center)
    .align(Alignment.Start)
    .padding({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
    .margin({ start: LengthMetrics.resource($r('app.float.toggle_label_text_indentation')) })
    .width(ConfigData.WH_60_100)
  }

  @Builder
  buildSelect() {
    Button({ type: ButtonType.Normal }) {
      Row() {
        Text(this.opts[this.selectedIndex.getState()])
          .fontSize($r('sys.float.Body_M'))
          .lineHeight(20)
          .fontColor($r('sys.color.font_primary'))
          .margin({ start: LengthMetrics.resource($r('app.float.hover_Comp_margin_padding')),
            end: LengthMetrics.resource($r('app.float.hover_Comp_margin_padding'))})
          .focusable(true)
        Row() {
          SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill')).fontSize(12).fontColor([$r('sys.color.font_primary')])
        }.justifyContent(FlexAlign.Center)
      }
      .id(COMPONENT_ID_SELECT)
      .align(Alignment.End)
      .bindMenu(this.isShowMenu, this.SelectMenu, { placement: Placement.BottomRight })
    }
    .borderRadius(8)
    .margin({
      right: $r('app.float.switchComp_padding_r'),
      left: $r('app.float.switchComp_padding_r'),
      top: $r('app.float.switchComp_padding_top'),
      bottom: $r('app.float.switchComp_padding_top')
    })
    .stateStyles({
      normal: {
        .backgroundColor(this.selectBackgroundColor)
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      }
    })
    .onHover((isHover) => {
      this.selectBackgroundColor = isHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent
    })
    .onClick(() => {
      this.isShowMenu = !this.isShowMenu;
    })
  }

  @Builder
  SelectMenu() {
    Column() {
      ForEach(this.menuItemVms, (item: MenuItemVm) => {
        SelectMenuItem({
          vm: item,
          itemMaxWidth: this.itemMaxWidth,
          maxItemIndex: this.maxItemIndex,
          selectedIndex: this.selectedIndex.getState(),
          selectEvent: (index: number) => {
            this.setSelectIndex(index)
            this.isShowMenu = false;
          }
        })
      })
    }
  }

  selectedIndexChange() {
    log.showInfo('selectedIndexChange');
    this.updateSelectValue();
    this.getMaxItemIndex();
  }

  private setSelectIndex(selectedIndex: number) {
    const oldIndex = this.selectedIndex.getState();
    log.showInfo(`setSelectIndex new:${selectedIndex}, old:${oldIndex}`);
    if (oldIndex === selectedIndex) {
      log.showInfo('selectedIndex not change, no need to deal');
      return;
    }
    this.selectedIndex.setState(selectedIndex);
    this.settingAction?.(selectedIndex);
  }

  private updateSelectValue() {
    const currentIndex = this.selectedIndex.getState();
    log.showInfo(`updateSelectValue new:${currentIndex}`);
    this.menuItemVms.forEach((item, index) => {
      item.isSelected = index === currentIndex;
    });
  }

  opts2MenuItemVms(opts: ResourceStr[]): MenuItemVm[] {
    return opts.map((item: ResourceStr, index: number) => {
      return new MenuItemVm(item, index);
    })
  }

  private getMaxItemIndex() {
    let maxWidth = 0;
    let finalIndex = 0;
    for (let i = 0; i < this.menuItemVms.length; i++) {
      let finalWidth: number = this.getTextSizeOptions(this.menuItemVms[i].text);
      // 计算宽度 文字宽度+选中时的margin和选中标识
      finalWidth = (this.menuItemVms[i].isSelected) ? finalWidth +
        vp2px(SELECTED_MARK_SIZE + SELECTED_MARK_MARGIN) : finalWidth;
      if (maxWidth < finalWidth) {
        maxWidth = finalWidth;
        finalIndex = i;
      }
    }
    this.maxItemIndex = finalIndex;
  }

  private getTextSizeOptions(textContent: string | Resource | undefined): number {
    return measure.measureText({
      textContent: textContent,
      overflow: TextOverflow.Ellipsis,
      fontWeight: FontWeight.Medium,
      fontSize: $r('sys.float.Body_L'),
      lineHeight: MENU_LINE_HEIGHT,
    });
  }
}

@Component
struct SelectMenuItem {
  @State itemBackgroundColor: ResourceColor = Color.Transparent;
  @Prop @Require vm: MenuItemVm;
  @Require selectEvent: (index: number) => void = () => {
    log.showError('selectEvent empty');
  };
  @Link itemMaxWidth: Length;
  @Prop selectedIndex: number = 0;
  @Prop maxItemIndex: number = 0;

  build() {
    Row() {
      Text(this.vm.text)
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
        .lineHeight(MENU_LINE_HEIGHT)
        .fontColor($r('sys.color.font_primary'))
      if (this.vm.isSelected) {
        Row() {
          SymbolGlyph($r('sys.symbol.checkmark'))
            .fontSize(SELECTED_MARK_SIZE)
            .fontWeight(FontWeight.Medium)
            .fontColor([$r('sys.color.font_primary')])
        }
        .justifyContent(FlexAlign.Center)
        .constraintSize({ minWidth: 24 })
        .height(24)
        .margin({ start: LengthMetrics.vp(SELECTED_MARK_MARGIN) })
      }
    }
    .width(this.isWidestItem(this.vm) ? undefined : this.itemMaxWidth)
    .onAreaChange((_oldArea, newArea) => {
      if (!this.isWidestItem(this.vm)) {
        return;
      }
      this.itemMaxWidth = newArea.width;
    })
    .justifyContent( FlexAlign.SpaceBetween)
    .constraintSize({ minWidth: 152, minHeight: 40 })
    .margin({ top: 1, bottom: 1 })
    .padding({ start: LengthMetrics.vp(12), end: LengthMetrics.vp(12) })
    .borderRadius(8)
    .stateStyles({
      normal: {
        .backgroundColor(this.itemBackgroundColor)
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      }
    })
    .onHover((isHover) => {
      this.itemBackgroundColor = isHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent;
    })
    .onClick(() => {
      this.selectEvent(this.vm.index);
    })
  }

  isWidestItem(menuItem: MenuItemVm): boolean {
    return menuItem.index === this.maxItemIndex;
  }
}

export class MenuItemVm {
  public text: ResourceStr;
  public isSelected: boolean = false;
  public index: number;

  constructor(text: ResourceStr, index: number) {
    this.text = text;
    this.index = index;
  }
}