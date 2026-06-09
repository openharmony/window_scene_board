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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { StatusBarType, styleMgr } from '@ohos/systemuicommon';
import { StatusBarGroupComponent } from './StatusBarGroupComponent';
import { StatusBarStyle } from '../style/PcStatusBarStyle';
import { StyleManager } from '../style/PluginStyleManager';
import { StatusBarTint } from '../../common/StatusBarTint';
import { LengthMetricsUtil } from '../common/LengthMetricsUtil';
import { StyleType } from '../utils/enum';
import { StatusBarPluginProperty } from '../plugingroup/viewdata/StatusBarPluginProperty';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { PositionProperty } from '../plugingroup/viewdata/PositionProperty';
import { PluginPositionType } from '../common/PluginConstants';
import { PluginPosUtils } from '../common/PluginPosUtil';
import { PluginSlot } from '@ohos/frameworkwrapper';

const TAG = 'PcStatusBarComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


/**
 * 状态栏根布局
 *
 * @since 2022-10-18
 */
@Component
export struct StatusBarComponent {
  /**
   * relative固定id
   */
  static readonly ROOT_ID = '__container__';
  /**
   * 左右group id前缀
   */
  private static readonly GROUP_ID_PRE = 'sbg';
  /**
   * 组件key值，状态栏key
   */
  private static readonly KEY_STATUS_BAR = 'status_bar';
  /**
   * 组件key值，状态栏左右容器key前缀
   */
  private static readonly KEY_GROUP_PRE = 'status_bar_group';
  /**
   * group区分左右位置
   */
  static readonly POSITION_GROUP_ALIGN: Map<boolean, AlignRuleOption> = new Map<boolean, AlignRuleOption>([
  // 左侧group父容器左对齐
    [true, {
      left: {
        anchor: StatusBarComponent.ROOT_ID,
        align: HorizontalAlign.Start
      },
      center: {
        anchor: StatusBarComponent.ROOT_ID,
        align: VerticalAlign.Center
      }
    }],
    // 右侧group父容器右对齐
    [false, {
      right: {
        anchor: StatusBarComponent.ROOT_ID,
        align: HorizontalAlign.End
      },
      center: {
        anchor: StatusBarComponent.ROOT_ID,
        align: VerticalAlign.Center
      }
    }]
  ]);
  /**
   * 状态栏类型，默认桌面状态栏
   */
  statusBarType: number = StatusBarType.TYPE_MAIN_MAC_STATUS_BAR;
  /**
   * 状态栏属性
   */
  @State statusBarProperty: StatusBarPluginProperty | null = null;
  @Prop leftPluginOpacity: number = 0;
  @Prop rightPluginOpacity: number = 0;
  @Prop isVisible: Boolean = true;
  @State statusBarStyle: StatusBarStyle | null = null;
  @Provide contentColor: string = StatusBarTint.CONTENT_COLOR_WHITE;
  @Provide iconsOpacityInfo: PluginSlot[] = [];
  /**
   * 初始化使用Hidden，避免首次开机切换时闪烁。初始化完成后改成None，通过renderGroup的缓存解决闪烁问题。
   */
  private hiddenModel: Visibility = Visibility.Hidden;
  @Prop opacityValue: number = 1;
  @Prop translateY: number = 0;
  @Prop blurRadius: number = 0;
  @Prop scaleValue: number = 1;

  /**
   * 获取状态栏类型
   * ComponentCallback复写
   *
   * @return 状态栏类型
   */
  getStatusBarType(): number {
    return this.statusBarType;
  }

  getRootId(): string {
    return StyleManager.getInstance().getStatusBarRootId();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear status bar type: ' + this.statusBarType);
    this.statusBarProperty = PluginGroupingManager.getInstance().getStatusBarPluginProperty();
    this.statusBarStyle = StyleManager.getInstance()
      .requestStyle(StyleType.STATUS_BAR, this.getRootId()) as StatusBarStyle;
  }

  /**
   * 解绑
   */
  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear type: ' + this.statusBarType);
  }

  private getGroupMargin(type: PluginPositionType): LocalizedMargin {
    // 修改状态栏间距
    return PluginPosUtils.isLeftArea(type) ?
      {
        top: LengthMetricsUtil.Length2LengthMetrics(this.statusBarStyle?.statusBarTopLeftPadding),
        start: LengthMetricsUtil.Length2LengthMetrics(this.statusBarStyle?.statusBarLeftPadding)
      } :
      {
        top: LengthMetricsUtil.Length2LengthMetrics(this.statusBarStyle?.statusBarTopPadding),
        end: LengthMetricsUtil.Length2LengthMetrics(this.statusBarStyle?.statusBarRightPadding)
      }
  }

  build() {
    RelativeContainer() {
      if (!ArrayUtils.isEmpty(this.statusBarProperty?.getTopPluginPosition())) {
        // 状态栏图标区域，区分左右
        ForEach(this.statusBarProperty?.getTopPluginPosition(), (groupProperty: PositionProperty, index: number) => {
          StatusBarGroupComponent({
            positionPos: groupProperty.getPositionType(),
            property: groupProperty,
            groupMargin: this.getGroupMargin(groupProperty.getPositionType()),
          })
        }, (infos: PositionProperty, index?: number) => this.getGroupPostion(index))
      }
    }
    .key(StatusBarComponent.KEY_STATUS_BAR)
    .onAreaChange(() => {
      this.hiddenModel = Visibility.None;
    })
    .width('100%')
    .height(styleMgr.isPCDPI200() ? px2vp(ResUtils.getNumber($r('app.float.status_bar_pc_height'))) :
    $r('app.float.had_status_bar_pc_height'))
    .renderGroup(this.isVisible?.valueOf() ?? true)
    .visibility(this.isVisible ? Visibility.Visible : this.hiddenModel)
    .opacity(this.opacityValue)
    .translate({ x: 0, y: this.translateY })
    .backgroundEffect({ radius: this.blurRadius })
    .position({ x: 0, y: 0 })
    .scale({
      x: this.scaleValue,
      y: this.scaleValue
    })
  }

  /**
   * 获取左右状态栏position
   *
   * @param index 索引
   * @return position 位置
   */
  private getGroupPostion(index?: number): string {
    if (!this.statusBarProperty) {
      return '';
    }
    return index === undefined ? '' : this.statusBarProperty.getTopPluginPosition()[index]
      .getPositionName() + this.statusBarType.toString();
  }
}