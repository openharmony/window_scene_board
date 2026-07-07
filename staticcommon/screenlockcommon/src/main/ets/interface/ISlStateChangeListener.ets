/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

import { SlMainStateType, SlSubStateType } from '../constants/SlStateType';

/**
 * 锁屏状态切换监听
 */
export interface ISlStateChangeListener {
  slMainStateType?: SlMainStateType; // 监听目标状态类型

  onSlStateChange?: (mainType: SlMainStateType, subType?: SlSubStateType) => void; // 状态变量值变化回调
}