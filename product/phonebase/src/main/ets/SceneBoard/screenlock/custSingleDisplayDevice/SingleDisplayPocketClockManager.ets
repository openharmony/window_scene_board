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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { clockWidgetConfigManager } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockWidgetConfigManager';
import { PocketVAlignKey } from '@ohos/screenlockwidget/src/main/ets/clock/common/HorizontalVerticalAlign';
import { DynamicLength } from '@ohos/screenlockwidget/src/main/ets/clock/common/DynamicLength';
import { ClockLayout, ClockWidgetId } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

enum AttrKey {
  DYNAMICOFFSETYMAP = 'dynamicOffsetYMap'
}

/**
 * 时钟元素配置
 */
interface ClockElementConfig {
  clockWidgetIds: ClockWidgetId[],
  attr: string,
  key?: PocketVAlignKey,
  value: number
}

/**
 * 小外屏时钟配置
 */
interface SingleDisplayClockConfig {
  clockLayout: ClockLayout,
  clockElements: ClockElementConfig[]
}

// 小折叠外屏时钟管理
export class SingleDisplayPocketClockManager {
  private static sInstance: SingleDisplayPocketClockManager;

  public static getInstance(): SingleDisplayPocketClockManager {
    if (!SingleDisplayPocketClockManager.sInstance) {
      SingleDisplayPocketClockManager.sInstance = new SingleDisplayPocketClockManager();
    }
    return SingleDisplayPocketClockManager.sInstance;
  }

  /**
   * 初始化
   */
  public init(): void {
      return;
  }

  /**
   * 更改时钟布局属性
   */
  private changeClockLayoutAttribute() {
    const singleDisplayPocketFoldClockConfig: SingleDisplayClockConfig[] =
      [this.clockLayout01, this.clockLayout02, this.clockLayout03, this.clockLayout04, this.clockLayout05,
        this.clockLayout08];
    singleDisplayPocketFoldClockConfig.forEach(v => {
      this.disposalClockConfig(v.clockElements, v.clockLayout);
    });
  }

  private disposalClockConfig(clockElements: ClockElementConfig[], clockLayout: ClockLayout) {
    clockElements.forEach(v => {
      const clockLayoutElements = clockWidgetConfigManager.getExpandClockStyleByType(clockLayout);
      v.clockWidgetIds.forEach(item => {
        const ele = clockLayoutElements?.find(e => e.id === item);
        if (ele) {
          switch (v.attr){
            case AttrKey.DYNAMICOFFSETYMAP:
              if (!ele?.dynamicOffsetYMap) {
                ele.dynamicOffsetYMap = DynamicLength.wrapper();
              }
              v?.key && ele.dynamicOffsetYMap?.buildProperty(v.key, v.value);
              break;
          }
        }
      });
    });
  }

  private get clockLayout01(): SingleDisplayClockConfig {
    const needUpdateClockLayout01: SingleDisplayClockConfig = {
      clockLayout: ClockLayout.DEFAULT_CLOCK_LAYOUT,
      clockElements: [
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 27
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 27
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_MINUTE0],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 129.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 129.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 240.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 240.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 265.6
        }
      ]
    };
    return needUpdateClockLayout01;
  }

  private get clockLayout02(): SingleDisplayClockConfig {
    const needUpdateClockLayout02: SingleDisplayClockConfig = {
      clockLayout: ClockLayout.NORMAL_CLOCK_LAYOUT,
      clockElements: [
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 13
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 25.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 38
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK, ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 93.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK, ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 106
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK, ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 118.6
        }
      ]
    };
    return needUpdateClockLayout02;
  }

  private get clockLayout03(): SingleDisplayClockConfig {
    const needUpdateClockLayout03: SingleDisplayClockConfig = {
      clockLayout: ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT,
      clockElements: [
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 14
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 26
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 38
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 71.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 83.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 95.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 97.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 109.6
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 121.6
        }
      ]
    };
    return needUpdateClockLayout03;
  }

  private get clockLayout04(): SingleDisplayClockConfig {
    const needUpdateClockLayout04: SingleDisplayClockConfig = {
      clockLayout: ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL,
      clockElements: [
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 14
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 30
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
            ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 46
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 65
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 81
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 97
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 63
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 79
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 95
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 88.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 104
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 120.6
        }
      ]
    };
    return needUpdateClockLayout04;
  }

  private get clockLayout05(): SingleDisplayClockConfig {
    const needUpdateClockLayout05: SingleDisplayClockConfig = {
      clockLayout: ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR,
      clockElements: [
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 109.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 109.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 109.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_START,
          value: 134.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 134.4
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_END,
          value: 134.4
        }
      ]
    };
    return needUpdateClockLayout05;
  }

  private get clockLayout08(): SingleDisplayClockConfig {
    const needUpdateClockLayout08: SingleDisplayClockConfig = {
      clockLayout: ClockLayout.DEFAULT_CLOCK_SPECIAL,
      clockElements: [
        {
          clockWidgetIds: [ClockWidgetId.ID_DATE],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 131.7
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_WEEK],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 131.7
        },
        {
          clockWidgetIds: [ClockWidgetId.ID_LUNA],
          attr: 'dynamicOffsetYMap',
          key: PocketVAlignKey.PV_CENTER,
          value: 156.7
        }
      ]
    };
    return needUpdateClockLayout08;
  }
}