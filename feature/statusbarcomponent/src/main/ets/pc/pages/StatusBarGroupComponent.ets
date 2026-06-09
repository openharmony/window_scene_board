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
import { PluginProperty } from '../viewdata/PluginProperty';
import { PcPluginRootComponent } from './PcPluginRootComponent';
import PcCapsuleComponent from './PcCapsuleComponent';
import StatusBarEventPoster from '../manager/StatusBarEventPoster';
import { GroupStyle } from '../style/PcStatusBarGroupStyle';
import { StateProperty } from '../manager/StateManager';
import { LocalGroup } from './StatusBarLocalGroup';
import { StyleManager } from '../style/PluginStyleManager';
import { StatusBarComponent } from './PcStatusBarComponent';
import curves from '@ohos.curves';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import { Constants } from '../common/Constants';
import { LengthMetrics } from '@kit.ArkUI';
import { StyleType } from '../utils/enum';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { PluginDisplayStyle, PluginGroupType, PluginPositionType } from '../common/PluginConstants';
import { GroupProperty } from '../plugingroup/viewdata/GroupProperty';
import { PositionProperty } from '../plugingroup/viewdata/PositionProperty';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { HiSysUtil } from '../utils/HiSysUtil';
import { PluginPosUtils } from '../common/PluginPosUtil';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'StatusBarGroupComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 状态栏group容器
 */
@Component
export struct StatusBarGroupComponent {
  private positionPos: PluginPositionType = PluginPositionType.TOP_LEFT;
  /**
   * plugin加载数据集
   */
  @State property: PositionProperty | undefined = undefined;
  @State dynamicProperty: GroupProperty | undefined = undefined;
  // 父组件观测不到dynamicProperty.pluginList数组的变化，在父组件中创建@State数组变量绑定dynamicProperty.pluginList
  @State pluginList: PluginProperty[] = [];
  /**
   * group样式
   */
  @State groupStyle: GroupStyle | null = null;

  private groupMargin: Margin | LocalizedMargin = {};

  build() {
    Row() {
      if (this.pluginList.length > 0) {
        CapsuleGroupComponent({
          property: this.dynamicProperty,
          style: this.groupStyle,
        })
      }
      GroupWrapperComponent({
        property: this.property,
        style: this.groupStyle,
        positionPos: this.positionPos,
      })
    }
    .alignRules(StatusBarComponent.POSITION_GROUP_ALIGN
      .get(PluginPosUtils.isLeftArea(this.property?.getPositionType())))
    .align(PluginPosUtils.isLeftArea(this.positionPos) ? Alignment.Start : Alignment.End)
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      if (this.positionPos === PluginPositionType.BOTTOM_RIGHT) {
        let property: PositionProperty =
          PluginGroupingManager.getInstance().getPluginPosition(PluginPositionType.BOTTOM_RIGHT);
        HiSysUtil.getInstance().hiSysOnIconItemsNumberChange(property);
      }
      this.dynamicProperty?.getPluginList().forEach((plug: PluginProperty) => {
        log.showInfo('plug:' + plug?.getSlot() + ', visible:' + plug?.isVisible());
      })
    })
    .margin(this.groupMargin)
  }

  aboutToAppear() {
    this.property = PluginGroupingManager.getInstance().getPluginPosition(this.positionPos);
    this.groupStyle = StyleManager.getInstance().requestStyle(StyleType.GROUP,
      this.property.getPositionName()) as GroupStyle;
    this.dynamicProperty = this.property.getSpecificPluginGroup(PluginGroupType.DYNAMIC_LEFT);
    // 防止数据先获取后被覆盖
    this.pluginList = this.dynamicProperty.getPluginList();
    this.dynamicProperty.setPluginList(this.pluginList);
    log.showInfo(`aboutToAppear, pos: ${this.positionPos}, len: ${this.pluginList.length}`);
  }

  aboutToDisappear(): void {
    log.showError('aboutToDisAppear');
  }
}

@Component
export struct CapsuleGroupComponent {
  @ObjectLink property: GroupProperty;
  @State style: GroupStyle | null = null;
  @State stateProperty: StateProperty | null = null;
  @State capsuleGroupWidth: number = 0;
  private widthChangeCurve: curves.ICurve = curves.interpolatingSpring(0, 1, 660, 66);
  @StorageLink('isDropAnimationGoing') @Watch('onDropAnimationStatusChanged') isDropAnimationGoing: boolean = false;
  @StorageProp('isModeChange') isModeChange: boolean = false;

  aboutToAppear(): void {
    log.showInfo('CapsuleGroupComponent aboutToAppear ' + this.property?.getPluginList().length);
    PcStatusBarDragMgr.getInstance().registerDynamicListNumChangeInDragCallback(this.onDynamicListNumChangeInDrag);
    this.property?.registerVisualPluginChangeCallback(this.visibleCallback);
  }

  aboutToDisappear(): void {
    log.showInfo('CapsuleGroupComponent aboutToDisappear ' + this.property?.getPluginList().length);
    PcStatusBarDragMgr.getInstance().unregisterDynamicListNumChangeInDragCallback(this.onDynamicListNumChangeInDrag);
    this.property?.unregisterVisualPluginChangeCallback(this.visibleCallback);
  }

  /**
   * 落位动画结束后更新状态栏
   */
  private onDropAnimationStatusChanged() {
    if (!this.isDropAnimationGoing) {
      log.showInfo('onDropAnimationStatusChanged');
      PcStatusBarDragMgr.getInstance().onDropAnimationEnd();
    }
  }

  visibleCallback = (lastNum: number, currentNum: number): void => {
    log.showInfo('visibleCallback, lastNum:' + lastNum + ' currentNum:' + currentNum);
    this.capsuleGroupWidth = this.property.getVisualPluginNum() * (Constants.PC_CAPSULE_PLUG_WIDTH +
    Constants.PC_CAPSULE_PLUG_MARGIN);
    if (!PcStatusBarDragMgr.getInstance().isStatusBarDragging && currentNum > lastNum) {
      PcStatusBarDragMgr.getInstance().checkDynamicExceedMaxWidth();
    }
  }

  @Builder
  windowStyleBuilder() {
    Row() {
      ForEach(this.property.getPluginList(), (property: PluginProperty) => {
        PcCapsuleComponent({
          pluginInfo: property?.pluginInfo,
          property: property,
          groupStyle: this.style,
        }) {
          PcPluginRootComponent({
            // 根组件唯一标示
            rootParentId: this.getRootId(),
            // plugin数据
            property: property,
            // 图标颜色
            // 是否为组合图标
            isGroupPlugin: false,
            onItemAreaChange: (oldArea: Area, newArea: Area) => {
              property.updatePluginArea(newArea);
              StatusBarEventPoster.getInstance().postAreaEvent(property.getSlot(), property.area);
            }
          })
        }
      }, (property: PluginProperty) => property.getSlot() +
      PluginDisplayStyle[PluginStyleUtil.getCurStatusBarType()])
    }
    .justifyContent(FlexAlign.End)
    .width(this.capsuleGroupWidth)
    .margin({ end: LengthMetrics.vp(2.5) })
  }

  build() {
    if (!ArrayUtils.isEmpty(this.property.getPluginList())) {
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

  private onDynamicListNumChangeInDrag = (addDynamicPlugNum: number, hasAnim: boolean,
    dynamicChanged: boolean = false): void => {
    log.showInfo(`onDynamicListNumChangeInDrag length: ${this.property?.getPluginList().length},  addDynamicPlugNum: ${addDynamicPlugNum}`);
    let calcWidth = this.capsuleGroupWidth;
    let visibleNum: number = 0;
    this.property.getPluginList().forEach((plug: PluginProperty) => {
      log.showError('onDynamicListNumChangeInDrag plug:' + plug?.getSlot() + ', visible:' + plug?.isVisible());
      if (plug?.isVisible()) {
        visibleNum++;
      }
    })
    calcWidth = (visibleNum + addDynamicPlugNum) * (Constants.PC_CAPSULE_PLUG_WIDTH + Constants.PC_CAPSULE_PLUG_MARGIN);
    if (hasAnim && !this.isModeChange) {
      animateTo({
        curve: this.widthChangeCurve,
        onFinish: () => {
          PcStatusBarDragMgr.getInstance().onDynamicAnimateFinish();
        }
      }, () => {
        this.capsuleGroupWidth = calcWidth;
      });
    } else {
      this.capsuleGroupWidth = calcWidth;
    }
    log.showInfo(`onDynamicListNumChangeInDrag capsuleGroupWidth: ${this.capsuleGroupWidth}`);
  };
}

@Component
struct GroupWrapperComponent {
  @ObjectLink property: PositionProperty;
  @State style: GroupStyle | null = null;
  private positionPos: PluginPositionType = PluginPositionType.TOP_LEFT;

  aboutToAppear(): void {
    log.showInfo('GroupWrapperComponent aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('GroupWrapperComponent aboutToDisappear');
  }

  build() {
    if (this.property) {
      Row() {
        // 遍历图标
        ForEach(this.property.getPluginGroupListExcludeDynamic(), (localGroup: GroupProperty) => {
          if (localGroup.getVisualPluginNum() > 0) {
            LocalGroup({
              localGroupProperty: localGroup,
              positionPos: this.positionPos,
            })
          }
        }, (localGroup: GroupProperty, index: number): string => {
          return localGroup.getGroupName() + index.toString() +
          PluginDisplayStyle[PluginStyleUtil.getCurStatusBarType()]
        })
      }
      .onAreaChange((oldArea: Area, newArea: Area) => {
        let width = ResUtils.getNumberFromLength(newArea.width);
        if (PluginPosUtils.isRightArea(this.positionPos)) {
          log.showInfo('GroupWrapperComponent onAreaChange width: ' + width);
          if (width !== PcStatusBarDragMgr.getInstance().getFixedAreaWidth()) {
            PcStatusBarDragMgr.getInstance().setFixedAreaWidth(width);
          }
        }
        log.showInfo(`localGroups length is ${this.property.getPluginGroupListExcludeDynamic().length} + position: ${this.positionPos}`);
        this.property.getPluginGroupListExcludeDynamic()?.forEach((group) => {
          log.showInfo(`localGroup is ${group?.getGroupName()},type is ${PluginStyleUtil.getCurStatusBarType()}`);
        })
      })
    }
  }
}