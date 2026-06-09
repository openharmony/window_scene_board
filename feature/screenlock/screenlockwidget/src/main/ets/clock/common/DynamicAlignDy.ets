/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2024. All rights reserved.
 */
import { DynamicNumber } from './DynamicNumber';
import { DynamicProperty } from './DynamicProperty';

// 动态对齐方式下的动态竖向偏移
export class DynamicAlignDy extends DynamicProperty<DynamicNumber> {

  private constructor() { // 私有构造
    super();
  }

  public static wrapper(): DynamicAlignDy {
    return new DynamicAlignDy();
  }
}