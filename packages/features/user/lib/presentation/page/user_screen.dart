import 'package:auto_route/annotations.dart';
import 'package:config/config.dart';
import 'package:core/injection/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_extension/shared_extension.dart';
import 'package:shared_ui/components/click/clickable.dart';
import 'package:shared_ui/components/idle/idle_item.dart';
import 'package:shared_ui/components/loading/loading_listview.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:theme/presentation/bloc/theme_bloc.dart';
import 'package:user/presentation/bloc/user_bloc.dart';

@RoutePage()
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: MyTheme.style.title.copyWith(
            color: MyTheme.color.white,
            fontSize: AppSetting.setFontSize(45),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: context.isDark
            ? context.containerColor
            : MyTheme.color.primary,
        actions: [
          /// Icon button choose popup menu button theme from Light, Dark or System
          PopupMenuButton<ThemeMode>(
            icon: Icon(Icons.more_vert, color: MyTheme.color.white),
            onSelected: (ThemeMode mode) {
              context.read<ThemeBloc>().setTheme(mode);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<ThemeMode>>[
                const PopupMenuItem<ThemeMode>(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                const PopupMenuItem<ThemeMode>(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
                const PopupMenuItem<ThemeMode>(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocProvider<UserBloc>(
        create: (context) => inject<UserBloc>()..fetchUsers(),
        child: const HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      context.read<UserBloc>().loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return state.when(
          initial: () => const IdleLoading(),
          loading: () => const LoadingListView(),
          error: (message) => IdleNoItemCenter(title: message),
          loaded: (users, page, hasReachedMax, onLoadMore) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    Clickable(
                      onClick: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar ?? ""),
                        ),
                        title: Text(
                          "${user.firstName} ${user.lastName}",
                          style: MyTheme.style.title.copyWith(
                            fontSize: AppSetting.setFontSize(45),
                          ),
                        ),
                        subtitle: Text(
                          user.email ?? "",
                          style: MyTheme.style.subtitle.copyWith(
                            fontSize: AppSetting.setFontSize(35),
                          ),
                        ),
                      ),
                    ),
                    if (index == users.length - 1 && onLoadMore) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSetting.setHeight(20),
                        ),
                      ),
                      LoadingListView(),
                    ],
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
