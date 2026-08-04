/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { NotificationGlassVm } from './NotificationGlassVm';

/**
 * 消息列表类，使用@Observed使数据更新时界面可以自动同步
 */
@Observed
export class NotificationGlassVmArray extends Array<NotificationGlassVm> {
}