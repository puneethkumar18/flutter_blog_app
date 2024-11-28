part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supaBase = await Supabase.initialize(
    anonKey: AppScreats.supabaseAnnonKey,
    url: AppScreats.supabaseUrl,
  );

  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;
  serviceLocator.registerLazySingleton(() => supaBase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  //CORE
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  //Connection Checker
  serviceLocator.registerFactory(
    () => InternetConnection(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositaryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLogIn(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      authRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  serviceLocator
    //RemoteDataSource
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLoacalDataSource>(
      () => BlogLoacalDataSourceImpl(
        serviceLocator(),
      ),
    )
    //BlogRepositary
    ..registerFactory<BlogRepositary>(
      () => BlogRepositaryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //UseCase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
