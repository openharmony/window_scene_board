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

import { CommonConstants } from '@ohos/launchercommon';
import { AreaOffset, ZoomHotArea, ZoomPosition } from './FormZoomCommonType';

export const HOT_AREA_WIDTH: number = 32;
export const HOT_AREA_HEIGHT: number = 32;
export const INVALID_FORM_ZOOM_ID: string = '-1';

export const LEFT_AREA: ZoomHotArea = {
  offsetX: '-50%',
  offsetY: '0%',
  width: HOT_AREA_WIDTH,
  height: 'calc(100% - 32vp)',
  position: ZoomPosition.LEFT,
};

export const LEFT_TOP_AREA: ZoomHotArea = {
  offsetX: '-50%',
  offsetY: '-50%',
  width: HOT_AREA_WIDTH,
  height: HOT_AREA_HEIGHT,
  position: ZoomPosition.LEFT_TOP,
};

export const TOP_AREA: ZoomHotArea = {
  offsetX: '0%',
  offsetY: '-50%',
  width: 'calc(100% - 32vp)',
  height: HOT_AREA_HEIGHT,
  position: ZoomPosition.TOP,
};

export const RIGHT_TOP_AREA: ZoomHotArea = {
  offsetX: '50%',
  offsetY: '-50%',
  width: HOT_AREA_WIDTH,
  height: HOT_AREA_HEIGHT,
  position: ZoomPosition.RIGHT_TOP,
};

export const RIGHT_AREA: ZoomHotArea = {
  offsetX: '50%',
  offsetY: '0%',
  width: HOT_AREA_WIDTH,
  height: 'calc(100% - 32vp)',
  position: ZoomPosition.RIGHT,
};

export const RIGHT_BOTTOM_AREA: ZoomHotArea = {
  offsetX: '50%',
  offsetY: '50%',
  width: HOT_AREA_WIDTH,
  height: HOT_AREA_HEIGHT,
  position: ZoomPosition.RIGHT_BOTTOM,
};

export const BOTTOM_AREA: ZoomHotArea = {
  offsetX: '0%',
  offsetY: '50%',
  width: 'calc(100% - 32vp)',
  height: HOT_AREA_HEIGHT,
  position: ZoomPosition.BOTTOM,
};

export const LEFT_BOTTOM_AREA: ZoomHotArea = {
  offsetX: '-50%',
  offsetY: '50%',
  width: HOT_AREA_WIDTH,
  height: HOT_AREA_HEIGHT,
  position: ZoomPosition.LEFT_BOTTOM,
};

// 缩小场景: 不同拖拽热区下的卡片对齐方式
// export const THEME_CARD_ZOOM_IN_ALIGN_MAP: Map<number, Map<number, Alignment[]>> = new Map([
export const THEME_CARD_ZOOM_IN_ALIGN_MAP: Map<number, Map<number, ESObject>> = new Map([
  [
    ZoomPosition.LEFT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopEnd]
      ]
    ])
  ],
  [
    ZoomPosition.TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.BottomStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.BottomStart]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopStart]
      ]
    ])
  ],
  [
    ZoomPosition.BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopStart]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.BottomEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.BottomEnd]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.BottomStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.BottomStart]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopStart]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopEnd]
      ]
    ])
  ],
]);

// 放大场景: 不同拖拽热区下的卡片对齐方式
// export const THEME_CARD_ZOOM_OUT_ALIGN_MAP: Map<number, Map<number, Alignment[]>> = new Map([
export const THEME_CARD_ZOOM_OUT_ALIGN_MAP: Map<number, Map<number, ESObject>> = new Map([
  [
    ZoomPosition.LEFT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopEnd,
          Alignment.BottomEnd,
          Alignment.Top,
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopEnd,
          Alignment.BottomEnd,
          Alignment.End,
          Alignment.Top,
          Alignment.Bottom,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.BottomStart,
          Alignment.BottomEnd,
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.BottomStart,
          Alignment.BottomEnd,
          Alignment.Bottom,
          Alignment.Start,
          Alignment.End,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopStart,
          Alignment.BottomStart,
          Alignment.Top,
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopStart,
          Alignment.BottomStart,
          Alignment.Start,
          Alignment.Top,
          Alignment.Bottom,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopStart,
          Alignment.TopEnd,
          Alignment.Top,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopStart,
          Alignment.TopEnd,
          Alignment.Top,
          Alignment.Start,
          Alignment.End,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.BottomEnd,
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.BottomEnd,
          Alignment.End,
          Alignment.Bottom,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.BottomStart,
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.BottomStart,
          Alignment.Start,
          Alignment.Bottom,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopStart,
          Alignment.Top,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopStart,
          Alignment.Top,
          Alignment.Start,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopEnd,
          Alignment.Top,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopEnd,
          Alignment.Top,
          Alignment.End,
          Alignment.Center,
        ]
      ]
    ])
  ],
]);

// 不同拖拽热区下默认的卡片对齐方式
export const THEME_CARD_ALIGN_DEFAULT_MAP: Map<number, Alignment> = new Map([
  [ZoomPosition.LEFT, Alignment.TopEnd],
  [ZoomPosition.TOP, Alignment.BottomStart],
  [ZoomPosition.RIGHT, Alignment.TopStart],
  [ZoomPosition.BOTTOM, Alignment.TopStart],
  [ZoomPosition.LEFT_TOP, Alignment.BottomEnd],
  [ZoomPosition.RIGHT_TOP, Alignment.BottomStart],
  [ZoomPosition.RIGHT_BOTTOM, Alignment.TopStart],
  [ZoomPosition.LEFT_BOTTOM, Alignment.TopEnd],
]);

// RTL语言下的卡片对齐映射关系
export const ALIGN_RTL_MAP: Map<Alignment, Alignment> = new Map([
  [Alignment.TopStart, Alignment.TopEnd],
  [Alignment.TopEnd, Alignment.TopStart],
  [Alignment.BottomStart, Alignment.BottomEnd],
  [Alignment.BottomEnd, Alignment.BottomStart],
  [Alignment.Start, Alignment.End],
  [Alignment.End, Alignment.Start],
  [Alignment.Top, Alignment.Top],
  [Alignment.Bottom, Alignment.Bottom],
]);

// 缩小场景: 不同卡片对齐方式、卡片尺寸下的布局偏移量
export const THEME_CARD_ZOOM_IN_MAP: Map<string, AreaOffset[]> = new Map([
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 0, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 0, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 0, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 0, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 1, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 2, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 1, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 2, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
]);

// 放大场景: 不同卡片对齐方式、卡片尺寸下的布局偏移量
export const THEME_CARD_ZOOM_OUT_MAP: Map<string, AreaOffset[]> = new Map([
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: 0, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: 0, columnOffset: -1, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: -1, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: 0, columnOffset: -2, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: -2, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.End + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -1, columnOffset: -2, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: -1, columnOffset: -2, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -2, columnOffset: -2, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: -1, columnOffset: -1, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -2, columnOffset: -1, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: -1, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -2, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.Start + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -1, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.Center + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -1, columnOffset: -1, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
]);

// export const NORMAL_CARD_ZOOM_IN_ALIGN_MAP: Map<number, Map<number, Alignment[]>> = new Map([
export const NORMAL_CARD_ZOOM_IN_ALIGN_MAP: Map<number, Map<number, ESObject>> = new Map([
  [
    ZoomPosition.LEFT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.End]
      ]
    ])
  ],
  [
    ZoomPosition.TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [Alignment.Bottom]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.Bottom]
      ],
      [
        CommonConstants.CARD_DIMENSION_6x4,
        [Alignment.Bottom]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.Start]
      ]
    ])
  ],
  [
    ZoomPosition.BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [Alignment.Top]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.Top]
      ],
      [
        CommonConstants.CARD_DIMENSION_6x4,
        [Alignment.Top]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.BottomEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.BottomEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_6x4,
        [Alignment.BottomEnd]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.BottomStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.BottomStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_6x4,
        [Alignment.BottomStart]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopStart]
      ],
      [
        CommonConstants.CARD_DIMENSION_6x4,
        [Alignment.TopStart]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [Alignment.TopEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [Alignment.TopEnd]
      ],
      [
        CommonConstants.CARD_DIMENSION_6x4,
        [Alignment.TopEnd]
      ]
    ])
  ],
]);

// export const NORMAL_CARD_ZOOM_OUT_ALIGN_MAP: Map<number, Map<number, Alignment[]>> = new Map([
export const NORMAL_CARD_ZOOM_OUT_ALIGN_MAP: Map<number, Map<number, ESObject>> = new Map([
  [
    ZoomPosition.LEFT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.End,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [
          Alignment.Bottom,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [
          Alignment.Bottom,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.Start,
          Alignment.Center,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.Top,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x4,
        [
          Alignment.Top,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_4x4,
        [
          Alignment.Top,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.BottomEnd,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.BottomEnd,
        ]
      ],
    ])
  ],
  [
    ZoomPosition.RIGHT_TOP,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.BottomStart,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.BottomStart,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.RIGHT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopStart,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopStart,
        ]
      ]
    ])
  ],
  [
    ZoomPosition.LEFT_BOTTOM,
    new Map([
      [
        CommonConstants.CARD_DIMENSION_1x2,
        [
          Alignment.TopEnd,
        ]
      ],
      [
        CommonConstants.CARD_DIMENSION_2x2,
        [
          Alignment.TopEnd,
        ]
      ]
    ])
  ],
]);

export const NORMAL_CARD_ZOOM_IN_MAP: Map<string, AreaOffset[]> = new Map([
  [
    Alignment.Start + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 0, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.End + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 0, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 0, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_6x4,
    [
      { rowOffset: 0, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset,
    ]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 1, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 2, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_6x4,
    [
      { rowOffset: 2, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 4, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset,
    ]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 0, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [
      { rowOffset: 0, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_6x4,
    [
      { rowOffset: 0, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 0, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 0, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_6x4,
    [
      { rowOffset: 0, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 0, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 1, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [
      { rowOffset: 2, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 2, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_6x4,
    [
      { rowOffset: 4, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 4, columnOffset: 0, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [{ rowOffset: 1, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [
      { rowOffset: 2, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 2, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_6x4,
    [
      { rowOffset: 4, columnOffset: 2, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset,
      { rowOffset: 4, columnOffset: 2, area: [2, 1], cardDimension: CommonConstants.CARD_DIMENSION_1x2 } as AreaOffset
    ]
  ],
]);

export const NORMAL_CARD_ZOOM_OUT_MAP: Map<string, AreaOffset[]> = new Map([
  [
    Alignment.Start + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.End + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: -2, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.Center + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: -1, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: 0, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: 0, columnOffset: -1, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [
      { rowOffset: 0, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.Top + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: 0, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [{ rowOffset: -1, columnOffset: 0, area: [2, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x2 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [{ rowOffset: -2, columnOffset: -1, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_2x4,
    [
      { rowOffset: -2, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: -4, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.Bottom + '_' + CommonConstants.CARD_DIMENSION_4x4,
    [{ rowOffset: -2, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [
      { rowOffset: 0, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.TopStart + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [
      { rowOffset: 0, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [
      { rowOffset: 0, columnOffset: -2, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: -2, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: -2, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.TopEnd + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [
      { rowOffset: 0, columnOffset: -2, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: 0, columnOffset: -2, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [
      {
        rowOffset: -1,
        columnOffset: -2,
        area: [4, 2],
        cardDimension: CommonConstants.CARD_DIMENSION_2x4
      } as AreaOffset,
      {
        rowOffset: -3,
        columnOffset: -2,
        area: [4, 4],
        cardDimension: CommonConstants.CARD_DIMENSION_4x4
      } as AreaOffset,
      {
        rowOffset: -5,
        columnOffset: -2,
        area: [4, 6],
        cardDimension: CommonConstants.CARD_DIMENSION_6x4
      } as AreaOffset
    ]
  ],
  [
    Alignment.BottomEnd + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [
      {
        rowOffset: -2,
        columnOffset: -2,
        area: [4, 4],
        cardDimension: CommonConstants.CARD_DIMENSION_4x4
      } as AreaOffset,
      { rowOffset: -4, columnOffset: -2, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_1x2,
    [
      { rowOffset: -1, columnOffset: 0, area: [4, 2], cardDimension: CommonConstants.CARD_DIMENSION_2x4 } as AreaOffset,
      { rowOffset: -3, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: -5, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
  [
    Alignment.BottomStart + '_' + CommonConstants.CARD_DIMENSION_2x2,
    [
      { rowOffset: -2, columnOffset: 0, area: [4, 4], cardDimension: CommonConstants.CARD_DIMENSION_4x4 } as AreaOffset,
      { rowOffset: -4, columnOffset: 0, area: [4, 6], cardDimension: CommonConstants.CARD_DIMENSION_6x4 } as AreaOffset
    ]
  ],
]);

export const NORMAL_CARD_ALIGN_DEFAULT_MAP: Map<number, Alignment> = new Map([
  [ZoomPosition.LEFT, Alignment.End],
  [ZoomPosition.TOP, Alignment.Bottom],
  [ZoomPosition.RIGHT, Alignment.Start],
  [ZoomPosition.BOTTOM, Alignment.Top],
  [ZoomPosition.LEFT_TOP, Alignment.BottomEnd],
  [ZoomPosition.RIGHT_TOP, Alignment.BottomStart],
  [ZoomPosition.RIGHT_BOTTOM, Alignment.TopStart],
  [ZoomPosition.LEFT_BOTTOM, Alignment.TopEnd],
]);