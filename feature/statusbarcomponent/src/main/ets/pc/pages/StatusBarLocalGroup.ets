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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PluginSlotMappingNew } from '../common/PluginSlotMappingNew';
import { StyleManager } from '../style/PluginStyleManager';
import { StateManager, StateProperty } from '../manager/StateManager';
import StatusBarEventPoster from '../manager/StatusBarEventPoster';
import { GroupProperty } from '../plugingroup/viewdata/GroupProperty';
import { PluginPositionType } from '../common/PluginConstants';
import { LocalGroupStyle } from '../style/LocalGroupStyle';
import { StyleType } from '../utils/enum';
import { PluginProperty } from '../viewdata/PluginProperty';
import { PcPluginRootComponent } from './PcPluginRootComponent';
import { LengthMetrics } from '@kit.ArkUI';
import { PluginPosUtils } from '../common/PluginPosUtil';

const TAG = 'LocalGroup';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const WHITE = '#FFFFFF';

@Component
export struct LocalGroup {
  @ObjectLink localGroupProperty: GroupProperty;
  private positionPos: PluginPositionType = PluginPositionType.TOP_LEFT;
  @State stateProperty: StateProperty | null = null;
  @State localGroupStyle: LocalGroupStyle | null = null;
  @Consume contentColor: string;
  @StorageProp('statusBarType') statusBarType: number = StatusBarType.TYPE_MAIN_MAC_STATUS_BAR;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear local group name:' + this.localGroupProperty.getGroupName() + ' position:' + this.positionPos);
    this.stateProperty = StateManager.getInstance().getState(this.localGroupProperty.getGroupName());
    this.localGroupStyle = StyleManager.getInstance()
      .requestStyle(StyleType.LOCAL_GROUP, this.localGroupProperty.getGroupName()) as LocalGroupStyle;
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear local group name:' + this.localGroupProperty.getGroupName() + ' position:' + this.positionPos);
  }

  @Builder
  pluginBuilder($$: PluginProperty, index: number, isLast: boolean, isGroupPlugin: boolean) {
    PcPluginRootComponent({
      // 根组件唯一标示
      rootParentId: this.getRootId(),
      // plugin数据
      property: $$.setIndex(index, isLast),
      isGroupPlugin: isGroupPlugin,
      updatePropertyMargin: (slot: string, index: number, statusBarType: number, isLast: boolean) => {
        StyleManager.getInstance().updatePluginMargin(slot, index, statusBarType, isLast);
      },
    })
  }

  @Styles
  eventReceiver() {
    .onAreaChange((oldArea, newArea) => {
      this.localGroupProperty.updateLocalGroupArea(newArea);
      StatusBarEventPoster.getInstance().postAreaEvent(this.localGroupProperty.getOpenPanel(),
        this.localGroupProperty.getGroupArea());
    })
    .onMouse((event) => {
      StatusBarEventPoster.getInstance()
        .postMouseEvent(event, this.localGroupProperty.getGroupName(), this.localGroupProperty.getOpenPanel());
    })
    .onTouch((event) => {
      StatusBarEventPoster.getInstance()
        .postTouchEvent(event, this.localGroupProperty.getGroupName(), this.localGroupProperty.getOpenPanel());
    })
    .onHover((isHovered: boolean, event: HoverEvent) => {
      StatusBarEventPoster.getInstance()
        .postHoverEvent(event, this.localGroupProperty.getGroupName(),
          this.localGroupProperty.getOpenPanel(), isHovered);
    })
    .onClick((event: ClickEvent) => {
      StatusBarEventPoster.getInstance()
        .postClickEvent(event, this.localGroupProperty.getGroupName(), this.localGroupProperty.getOpenPanel());
    })
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture({ repeat: false })
          .onAction((event) => {
            StatusBarEventPoster.getInstance()
              .postLongClickEvent(event, this.localGroupProperty.getOpenPanel(),
                this.localGroupProperty.getOpenPanel());
          })
      )
    )
  }

  @Styles
  borderStyles() {
    .borderRadius({
      topLeft: this.localGroupStyle?.localGroupBorderTopLeft,
      topRight: this.localGroupStyle?.localGroupBorderTopRight,
      bottomLeft: this.localGroupStyle?.localGroupBorderBottomLeft,
      bottomRight: this.localGroupStyle?.localGroupBorderBottomRight,
    })
  }

  @Builder
  mySeparator() {
    if (PluginSlotMappingNew.isNeedSeparator(this.localGroupProperty.getOpenPanel())) {
      Divider()
        .vertical(true)
        .strokeWidth(1)
        .width(1)
        .height(20)
        .color(this.contentColor)
        .opacity(0.2)
        .id(`${TAG}_Divider`)
        .margin({
          // 左侧OpenHarmony环容器变大，向左偏移10vp保证布局不变
          start: LengthMetrics.vp(this.positionPos === PluginPositionType.BOTTOM_LEFT ? -2 : 2),
          end: LengthMetrics.vp(this.positionPos === PluginPositionType.BOTTOM_LEFT ? 8 : 2)
        })
    }
  }

  @Builder
  windowStyleBuilder() {
    this.mySeparator()
    Row() {
      ForEach(this.localGroupProperty.getPluginList(), (property: PluginProperty, index: number) => {
        this.pluginBuilder(property, index, false, true)
      }, (property: PluginProperty) => property.getSlot())
    }
    .id(`PluginRootComponent_Stack_${this.localGroupProperty?.getOpenPanel()}`)
    .borderStyles()
    .eventReceiver()
    .backgroundColor(this.isNeedBackground() ?
    this.localGroupStyle?.getCurrentBgColorByContentColor(this.contentColor === WHITE, this.stateProperty?.isSelected,
      this.stateProperty?.isHovered, this.stateProperty?.isClicked) : undefined)
    .margin({
      end: LengthMetrics.vp(this.localGroupProperty?.getOpenPanel() === PluginSlot.SLOT_STATUS_INPUT_PANEL ? 2.5 : 0),
    })
  }

  build() {
    if (this.localGroupProperty.isExistPlugins()) {
      this.windowStyleBuilder()
    }
  }
  /**
   * 获取组件唯一标示
   *
   * @return 组件标示
   */
  private getRootId(): string {
    return StyleManager.getInstance().getStatusBarRootId();
  }

  private isNeedBackground(): boolean {
    let length = this.localGroupProperty.getPluginList().length;
    if (length < 1) {
      return false;
    }
    switch (this.localGroupProperty.getPluginList()[0]?.pluginInfo?.pluginParseInfo.pluginSlot) {
      case PluginSlot.SLOT_STATUS_HOS_KEY:
      default:
        return true;
    }
  }
}